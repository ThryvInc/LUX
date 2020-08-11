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

class ComparisonTableViewController: UITableViewController {
    var cancelBag = Set<AnyCancellable?>()
    let call = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())
    var reigns = [Reign]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // stubbing
        call.firingFunc = { $0.responder?.data = json.data(using: .utf8) }
        
        cancelBag.insert(call.responder?.$data
            .compactMap({ $0 })
            .compactMap({
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                return try? decoder.decode(Cycle.self, from: $0)
            }).sink {
                self.title = "\($0.ordinal ?? 0)th Cycle"
                self.reigns = $0.reigns
                self.tableView.refreshControl?.endRefreshing()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @objc func refresh() {
        tableView.refreshControl?.beginRefreshing()
        call.fire()
    }
    
    func onTap(reign: Reign) {}
    
    // MARK: - Table data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return reigns.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reigns[section].emperors?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return reignToHouseString(reigns[section])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = reigns[indexPath.section].emperors?[indexPath.row].name ?? "<Unknown>"
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Table delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        onTap(reign: reigns[indexPath.row])
    }
}

let vc = ComparisonTableViewController()
let nc = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = nc
PlaygroundPage.current.needsIndefiniteExecution = true
