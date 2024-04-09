//
//  ListFavorite.swift
//  Games
//
//  Created by Monica Sucianto on 29/12/23.
//

import SwiftUI

struct ListFavorite: View {
    @State var games:[FavGame] = []
    var gameProvider: GameProvider = GameProvider()
    var body: some View {
        NavigationStack{
            VStack{
                if !games.isEmpty{
                    ScrollView{
                        ForEach(games) { game in
                            Favcell(game: game)
                        }
                    }
                }else{
                    VStack{
                        Text("No favorite games")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                        Text("Start saving games to favorite")
                            .font(.subheadline)
                        
                    } .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
            .background{
                LinearGradient(gradient: Gradient(colors: [.maroon, .darkPurple,.darkPurple2,.darkPurple3]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            }
            .navigationTitle("Favorites")
            .onAppear{
                gameProvider.getAllGames { games in
                    DispatchQueue.main.async{
                        self.games=games
                    }
                }
            }
        }
    }
}


struct Favcell: View {
    let game: FavGame
    
    var body: some View {
        NavigationLink(destination: DetailView(gameId: game.id)){
            HStack {
                OnlineImage(url: game.bgImage ?? "", width: 100, height: 100)
                VStack(alignment:.leading){
                    Text(game.name ?? "N/A").font(.title3).fontWeight(.semibold)
                    Text("Released date: \(game.released ?? "N/A")").fontWeight(.light).font(.caption)
                }
                Spacer()
                VStack(alignment:.center,spacing:10){
                    Image(systemName: "star.fill")
                    Text(String(format: "%.2f", game.rating ?? "N/A"))
                    
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

//#Preview {
//    ListFavorite()
//}
