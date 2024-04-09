import SwiftUI

struct SearchView: View {
    init() {
        UISearchBar.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
        UISearchTextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder =
        NSAttributedString(string:"Search", attributes: [.foregroundColor: UIColor.lightGray])
    }
    @State private var query: String = ""
    @StateObject private var network = NetworkService()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !query.isEmpty {
                    ScrollView(showsIndicators:false) {
                        ForEach(network.games4) { game in
                            GameCell(game: game)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 15)
                } else {
                    Text("Find games")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                    Text("Start searching for more games")
                        .font(.subheadline)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.maroon, .darkPurple, .darkPurple2, .darkPurple3]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .searchable(text: $query) {}
            
            .onChange(of: query) {
                network.fetchData(query: query, pageSize: "10")
            }
        }
    }
}

struct GameCell: View {
    let game: Game
    
    var body: some View {
        NavigationLink(destination: DetailView(gameId: game.id)){
            HStack {
                OnlineImage(url: game.bgImage, width: 100, height: 100)
                Text(game.name)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SearchView()
}
