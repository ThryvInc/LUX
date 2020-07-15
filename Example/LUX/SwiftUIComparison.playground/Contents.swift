import SwiftUI
import PlaygroundSupport
import Slippers
import LUX
import FunNet
import Combine
import Prelude
import LithoOperators

NSSetUncaughtExceptionHandler { exception in
    print("💥 Exception thrown: \(exception)")
}

//Models
enum House: String, Codable, CaseIterable {
    case phoenix, dragon, lyorn, tiassa, hawk, dzur, issola, tsalmoth, vallista, jhereg, iorich, chreotha, yendi, orca, teckla, jhegaala, athyra
}
struct Emperor: Codable { var name: String? }
struct Reign: Codable, Identifiable {
    var id: Int
    var house: House
    var emperors: [Emperor]?
}
struct Cycle: Codable {
    var ordinal: Int?
    var reigns = [Reign]()
}

let reigns = [
    Reign(id: 188, house: .phoenix, emperors: []),
    Reign(id: 189, house: .dragon, emperors: [Emperor(name: "Norathar I")]),
    Reign(id: 190, house: .lyorn, emperors: [Emperor(name: "Cuorfor II")]),
    Reign(id: 191, house: .tiassa),
    Reign(id: 192, house: .hawk, emperors: []),
    Reign(id: 193, house: .dzur),
    Reign(id: 194, house: .issola, emperors: [Emperor(name: "Juzai XI")]),
    Reign(id: 195, house: .tsalmoth, emperors: [Emperor(name: "Faarith III")]),
    Reign(id: 196, house: .vallista, emperors: [Emperor(name: "Fecila III")]),
    Reign(id: 197, house: .jhereg),
    Reign(id: 198, house: .iorich, emperors: [Emperor(name: "Synna IV")]),
    Reign(id: 199, house: .chreotha),
    Reign(id: 200, house: .yendi),
    Reign(id: 201, house: .orca),
    Reign(id: 202, house: .teckla, emperors: [Emperor(name: "Kiva IV")]),
    Reign(id: 203, house: .jhegaala),
    Reign(id: 204, house: .athyra)
]
let eleventhCycle = Cycle(ordinal: 11, reigns: reigns)

struct PullToRefresh: UIViewRepresentable {
    let action: () -> Void
    @Binding var isShowing: Bool
    
    public init(action: @escaping () -> Void, isShowing: Binding<Bool>) {
        self.action = action
        _isShowing = isShowing
    }
    
    public class Coordinator {
        let action: () -> Void
        let isShowing: Binding<Bool>
        
        init(action: @escaping () -> Void, isShowing: Binding<Bool>) {
            self.action = action
            self.isShowing = isShowing
        }
        
        @objc func onValueChanged() {
            isShowing.wrappedValue = true
            action()
        }
    }
    
    public func makeUIView(context: UIViewRepresentableContext<PullToRefresh>) -> UIView {
        return UIView(frame: .zero)
    }
    
    private func tableView(root: UIView) -> UITableView? {
        for subview in root.subviews {
            if let tableView = subview as? UITableView {
                return tableView
            } else if let tableView = tableView(root: subview) {
                return tableView
            }
        }
        return nil
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PullToRefresh>) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let viewHost = uiView.superview?.superview else { return }
            guard let tableView = self.tableView(root: viewHost) else { return }
            
            if let refreshControl = tableView.refreshControl {
                self.isShowing ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
            } else {
                tableView.refreshControl = UIRefreshControl()
                tableView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.onValueChanged), for: .valueChanged)
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(action: action, isShowing: $isShowing)
    }
}

extension View {
    public func pullToRefresh(action: @escaping () -> Void, isShowing: Binding<Bool>) -> some View {
        return overlay(PullToRefresh(action: action, isShowing: isShowing)
                .frame(width: 0, height: 0)
        )
    }
}

//model manipulation
let capitalizeFirstLetter: (String) -> String = { $0.prefix(1).uppercased() + $0.lowercased().dropFirst() }
let houseToString: (House) -> String = { String(describing: $0) }
let reignToHouseString: (Reign) -> String = ^\Reign.house >>> houseToString >>> capitalizeFirstLetter
func first<T>(_ array: [T]) -> T? { return array.first }
let reignToEmperor: (Reign) -> String = { return $0.emperors?.first?.name ?? "<Unknown>"}

//Row content
struct DetailRowContent: View {
    var titleString: String?
    var detailString: String?
    var body: some View {
        VStack(alignment: .leading) {
            Text(titleString ?? "").font(.system(size: 18))
            Text(detailString ?? "").font(.system(size: 14))
        }
    }
}

func modelToDetailRow<T>(_ titleFunction: @escaping (T) -> String?, _ detailFunction: @escaping (T) -> String?) -> (T) -> DetailRowContent {
    return { t in
        return DetailRowContent(titleString: titleFunction(t), detailString: detailFunction(t))
    }
}

let reignToRow: (Reign) -> DetailRowContent = modelToDetailRow(reignToEmperor, reignToHouseString)

let call = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())

//just for stubbing purposes
call.firingFunc = { call in
    let page: Int = call.endpoint.getParams["page"] as! Int
    let per: Int = call.endpoint.getParams["count"] as! Int
    DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
        DispatchQueue.main.async {
            call.publisher.response = nil
            call.publisher.data = JsonProvider.encode(Cycle(ordinal: 11, reigns: reigns.page(number: page - 1, per: per)))
        }
    }
}

let cyclePub: AnyPublisher<Cycle, Never> = modelPublisher(from: call.publisher.$data.eraseToAnyPublisher())

var cancelBag = Set<AnyCancellable>()
let dataPub = call.publisher.$data.eraseToAnyPublisher()
let modelPub = unwrappedModelPublisher(from: dataPub, ^\Cycle.reigns)
let pageManager = LUXPageCallModelsManager(defaultCount: 5, call, modelPub)

extension LUXPageCallModelsManager where T: Identifiable {
    func didAppearFunction(pageSize: Int = 20, pageTrigger: Int = 5) -> (T) -> Void {
        return { t in
            var index = 0
            for model in self.models {
                if t.id == model.id { break }
                index += 1
            }
            let numberOfRows = self.models.count
            if numberOfRows - index == pageTrigger && numberOfRows % pageSize == 0  {
                self.nextPage()
            }
        }
    }
}
extension LUXPageCallModelsManager: ObservableObject {}

protocol TitleProvider {
    func title() -> String
}

class CycleViewModel: ObservableObject, TitleProvider {
    let cyclePublisher: AnyPublisher<Cycle, Never>
    @Published var cycle: Cycle?
    var cancelBag = Set<AnyCancellable>()
    
    init(_ cyclePublisher: AnyPublisher<Cycle, Never>) {
        self.cyclePublisher = cyclePublisher
        cyclePublisher.sink { [unowned self] cycle in self.cycle = cycle }.store(in: &cancelBag)
    }
    
    func title() -> String {
        return cycle?.ordinal == nil ? "Loading..." : "The \(cycle?.ordinal ?? 0)th Cycle"
    }
}

struct ContentView<T, U, V>: View where T: Decodable & Identifiable,
                                        U: View,
                                        V: ObservableObject & TitleProvider {
    @ObservedObject var viewModel: V
    @ObservedObject var pageManager: LUXPageCallModelsManager<T>
    var rowCreator: (T) -> U
    var rowAppearedFunction: (T) -> Void
    @State var isFinished: Bool = false
    
    var body: some View {
        NavigationView {
            List(self.pageManager.models, rowContent: pagingTrackerRow)
                .pullToRefresh(action: self.pageManager.refresh, isShowing: self.$pageManager.isFetching)
                .navigationBarTitle(viewModel.title())
        }.onAppear(perform: pageManager.refresh)
    }
    
    func pagingTrackerRow(_ model: T) -> some View {
        return rowCreator(model).onAppear(perform: voidCurry(model, rowAppearedFunction))
    }
}

let contentView = ContentView(viewModel: CycleViewModel(cyclePub),
                              pageManager: pageManager,
                              rowCreator: reignToRow,
                              rowAppearedFunction: pageManager.didAppearFunction())

PlaygroundPage.current.liveView = UIHostingController.init(rootView: contentView)
