import UIKit
import PlaygroundSupport
@testable import LUX
@testable import FunNet
import Prelude
import Combine
import MultiModelTableViewDataSource
import LithoOperators

//Models ------------------------------------------------------------------------------------------------------
struct Emperor: Codable { var name: String? }
enum House: String, Codable, CaseIterable {
    case phoenix, dragon, lyorn, tiassa, hawk, dzur, issola, tsalmoth, vallista, jhereg, iorich, chreotha, yendi, orca, teckla, jhegaala, athyra
}
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

// table view cell subclass -------------------------------------------------------------------------------------
class DetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//model manipulation functions -------------------------------------------------------------------------------------
let capitalizeFirstLetter: (String) -> String = { $0.prefix(1).uppercased() + $0.lowercased().dropFirst() }
let parseCycle: (Data) -> Cycle? = { try? LUXJsonProvider.jsonDecoder.decode(Cycle.self, from: $0) }
let houseToString: (House) -> String = { String(describing: $0) }
let reignToHouseString: (Reign) -> String = ^\Reign.house >>> houseToString >>> capitalizeFirstLetter


//model display functions -------------------------------------------------------------------------------------
let buildHouseConfigurator: (Reign) -> (UITableViewCell) -> Void = { reign in return { $0.textLabel?.text = reignToHouseString(reign) }}

//go from configuring functions to a table view data source ---------------------------------------------------
func configuratorToItem(configurer: @escaping (UITableViewCell) -> Void) -> MultiModelTableViewDataSourceItem { return FunctionalMultiModelTableViewDataSourceItem<DetailTableViewCell>(identifier: "cell", configurer) }
let configsToDataSource = configuratorToItem >||> map >>> itemsToSection >>> arrayOfSingleObject >>> sectionsToDataSource

//setup
let vc = LUXSearchViewController<LUXModelListViewModel<Reign>, Reign>(nibName: "LUXSearchViewController", bundle: Bundle(for: LUXSearchViewController<LUXModelListViewModel<Reign>, Reign>.self))

let call = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())
vc.lastScreenYForAnimation = 96

//just for stubbing purposes
call.firingFunc = { $0.responder?.data = json.data(using: .utf8) }

let dataSignal = (call.responder?.$data)!.eraseToAnyPublisher()
let modelsSignal: AnyPublisher<[Reign], Never> = unwrappedModelPublisher(from: dataSignal, ^\Cycle.reigns)
let onTap: () -> Void = {}

let searcher = LUXSearcher<Reign> { text, reign in
    guard let text = text, text != "" else {
        return true
    }
    return reignToHouseString(reign).prefix(text.count) == text
}
vc.searcher = searcher
vc.onSearch = { text in
    searcher.updateSearch(text: text)
}

let refreshManager = LUXRefreshCallModelsManager<Reign>(call, modelsSignal)
vc.refreshableModelManager = refreshManager

let viewModel = LUXModelListViewModel(modelsPublisher: searcher.filteredPublisher(from: modelsSignal), modelToItem: buildHouseConfigurator >>> configuratorToItem)
vc.viewModel = viewModel
vc.tableViewDelegate = LUXTappableTableDelegate(viewModel.dataSource)

PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true
