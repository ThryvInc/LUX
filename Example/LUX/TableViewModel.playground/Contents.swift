import UIKit
import PlaygroundSupport
@testable import LUX
@testable import FunNet
import Combine
import Prelude
import FlexDataSource
import LithoOperators
import PlaygroundVCHelpers

//Models
enum House: String, Codable, CaseIterable {
    case phoenix, dragon, lyorn, tiassa, hawk, dzur, issola, tsalmoth, vallista, jhereg, iorich, chreotha, yendi, orca, teckla, jhegaala, athyra
}
struct Emperor: Codable { var name: String? }
struct Reign: Codable {
    var house: House
    var emperors: [Emperor]?
}
struct Cycle: Codable {
    var ordinal: Int?
    var reigns = [Reign]()
}

let json = """
{ "ordinal": 18,
  "reigns":[{"house":"phoenix", "emperors": [{"name":"Tortaalik I"},{"name":"Zerika IV"}]},
            {"house":"dragon", "emperors": [{"name":"Norathar II"}]},
            {"house":"lyorn"},
            {"house":"tiassa"},
            {"house":"hawk", "emperors": [{"name":"??Paarfi I of Roundwood (the Wise)??"}]},
            {"house":"dzur"},
            {"house":"issola"},
            {"house":"tsalmoth"},
            {"house":"vallista"},
            {"house":"jhereg"},
            {"house":"iorich"},
            {"house":"chreotha"},
            {"house":"yendi"},
            {"house":"orca"},
            {"house":"teckla"},
            {"house":"jhegaala"},
            {"house":"athyra"}]
}
"""

//model manipulation
let capitalizeFirstLetter: (String) -> String = { $0.prefix(1).uppercased() + $0.lowercased().dropFirst() }
let houseToString: (House) -> String = { String(describing: $0) }
let reignToHouseString: (Reign) -> String = get(\Reign.house) >>> houseToString >>> capitalizeFirstLetter

//table view cell subclass
class DetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//linking models to views
let emperorToItemCreator: (@escaping (Emperor) -> Void) -> (Emperor) -> FlexDataSourceItem = emperorConfigurator >||> (onTap >|||> LUXTappableModelItem.init)
func reignToSection(_ emperorToItem: @escaping (Emperor) -> FlexDataSourceItem) -> (Reign) -> FlexDataSourceSection {
    return {
        let section = FlexDataSourceSection()
        section.title = reignToHouseString($0)
        section.items = $0.emperors?.map(emperorToItem)
        return section
    }
}

let emperorConfigurator: (Emperor, UITableViewCell) -> Void = { emperor, cell in
    cell.textLabel?.text = emperor.name ?? "<Unknown>"
}

//setup
let vc = LUXFunctionalTableViewController.makeFromXIB()
let nc = UINavigationController(rootViewController: vc)
let onTap: (Emperor) -> Void = { _ in }

let call = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())

//just for stubbing purposes
call.firingFunc = { $0.responder?.data = json.data(using: .utf8) }

let dataSignal = (call.responder?.$data)!.eraseToAnyPublisher()
let modelsSignal = unwrappedModelPublisher(from: dataSignal, ^\Cycle.reigns)

let cycleSignal: AnyPublisher<Cycle, Never> = modelPublisher(from: dataSignal)
let cancel = cycleSignal.sink { vc.title = "\($0.ordinal ?? 0)th Cycle" }

let refreshManager = LUXRefreshableNetworkCallManager(call)
let vm = LUXSectionsTableViewModel(refreshManager, modelsSignal.map(reignToSection(emperorToItemCreator(onTap)) >||> map).eraseToAnyPublisher())
let cancel3 = dataSignal.sink { _ in vm.endRefreshing() }

vm.tableDelegate = LUXFunctionalTableDelegate(onSelect: (vm.dataSource as! FlexDataSource).onSelect)

vc.onViewDidLoad = {
    $0.view.backgroundColor = UIColor.white
    
    vm.tableView = $0.tableView
    vm.refresh()
}

PlaygroundPage.current.liveView = nc
PlaygroundPage.current.needsIndefiniteExecution = true
