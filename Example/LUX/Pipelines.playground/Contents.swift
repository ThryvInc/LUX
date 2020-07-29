import UIKit
import PlaygroundSupport
import Slippers
@testable import LUX
@testable import FunNet
import Prelude
import FlexDataSource
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
let parseCycle: (Data) -> Cycle? = { JsonProvider.decode(Cycle.self, from: $0) }
let houseToString: (House) -> String = { String(describing: $0) }
let reignToHouseString: (Reign) -> String = ^\Reign.house >>> houseToString >>> capitalizeFirstLetter







//model display functions -------------------------------------------------------------------------------------
let buildHouseConfigurator: (Reign) -> (UITableViewCell) -> Void = { reign in return { $0.textLabel?.text = reignToHouseString(reign) }}
let buildReignConfigurator: (Reign) -> (UITableViewCell) -> Void = { reign in
    return {
        if let emperorName = reign.emperors?.first?.name {
            $0.textLabel?.text = emperorName
        } else {
            $0.textLabel?.text = "<None yet>"
        }
        $0.detailTextLabel?.text = reignToHouseString(reign)
    }
}
let buildReignConfigs: ([Reign]) -> [(UITableViewCell) -> Void] = buildReignConfigurator >||> map







//go from configuring functions to a table view data source ---------------------------------------------------
func configuratorToItem(configurer: @escaping (UITableViewCell) -> Void) -> FlexDataSourceItem { return FunctionalFlexDataSourceItem<DetailTableViewCell>(identifier: "cell", configurer) }
let configsToDataSource = configuratorToItem >||> map >>> itemsToSection >>> arrayOfSingleObject >>> sectionsToDataSource






//pipelines! ------------------------------------------------------------------------------------------------------
let cyclePipeline = ^\Cycle.reigns >?> ((buildReignConfigurator >||> map) >>> configsToDataSource)
let housesPipeline = ^\Cycle.reigns >?> ((buildHouseConfigurator >||> map) >>> configsToDataSource)






//our view controller ---------------------------------------------------------------------------------------------
class CycleViewController : UITableViewController {
    var cycle: Cycle? {
        didSet {
            if let cycle = cycle {
                title = "\(cycle.ordinal ?? 0)th Cycle"
                dataSource = cyclePipeline(cycle) //change pipelines here!
            }
        }
    }
    var dataSource: FlexDataSource? {
        didSet {
            setupDataSource()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCycle()
    }
    
    func fetchCycle() {
        if let jsonData = json.data(using: .utf8) {
            cycle = parseCycle(jsonData)
        }
    }
    
    func setupDataSource() {
        if let ds = dataSource {
            ds.tableView = tableView
            tableView.dataSource = ds
            tableView.reloadData()
        }
    }
}

let nc = UINavigationController(rootViewController: CycleViewController())

PlaygroundPage.current.liveView = nc
PlaygroundPage.current.needsIndefiniteExecution = true
