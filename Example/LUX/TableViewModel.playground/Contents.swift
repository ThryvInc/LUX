import UIKit
import PlaygroundSupport
@testable import LUX
@testable import FunNet
import Combine
import Prelude
import MultiModelTableViewDataSource
import LithoOperators

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
  "reigns":[{"house":"phoenix", "emperors": [{"name":"Zerika IV"}]},
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

func configuratorToItem(configurer: @escaping (UITableViewCell) -> Void, onTap: @escaping () -> Void) -> MultiModelTableViewDataSourceItem { return TappableFunctionalMultiModelItem<DetailTableViewCell>(identifier: "cell", configurer, onTap) }

//linking models to views
let buildConfigurator: (Reign) -> (UITableViewCell) -> Void = { reign in
    return {
        if let emperorName = reign.emperors?.first?.name {
            $0.textLabel?.text = emperorName
        } else {
            $0.textLabel?.text = "<Unknown>"
        }
        $0.detailTextLabel?.text = reignToHouseString(reign)
    }
}

//setup
let call = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())

//just for stubbing purposes
call.firingFunc = {
    $0.responder?.data = json.data(using: .utf8)
}

let dataSignal = (call.responder?.$data)!.eraseToAnyPublisher()
let modelsSignal: AnyPublisher<[Reign], Never> = unwrappedModelPublisher(from: dataSignal, ^\Cycle.reigns)

let vc = LUXFunctionalTableViewController(nibName: "LUXFunctionalTableViewController", bundle: Bundle(for: LUXFunctionalTableViewController.self))

let nc = UINavigationController(rootViewController: vc)
let onTap: () -> Void = {}

let cycleSignal: AnyPublisher<Cycle, Never> = modelPublisher(from: dataSignal)
let cancel = cycleSignal.sink {
    vc.title = "\($0.ordinal ?? 0)th Cycle"
}

let modelToItem = buildConfigurator >>> (onTap >||> configuratorToItem)

let refreshManager = LUXRefreshableNetworkCallManager(call)
let modelsToItems = modelToItem >||> map
let vm = LUXItemsTableViewModel(refreshManager, itemsPublisher: modelsSignal.map(modelsToItems).eraseToAnyPublisher())

let cancel3 = dataSignal.sink { _ in
    vm.endRefreshing()
}

if let ds = vm.dataSource as? MultiModelTableViewDataSource {
    vm.tableDelegate = LUXTappableTableDelegate(ds)
}

vc.onViewDidLoad = {
    $0.view.backgroundColor = UIColor.white
    
    vm.tableView = $0.tableView
    vm.refresh()
}

PlaygroundPage.current.liveView = nc
PlaygroundPage.current.needsIndefiniteExecution = true