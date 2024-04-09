//
//  DetailView.swift
//  Games
//
//  Created by Monica Sucianto on 26/12/23.
//

import SwiftUI
import SimpleToast

struct DetailView: View {
    let resId:Int
    @State var isLove: Bool = false
    var gameProvider: GameProvider = GameProvider()
    @StateObject var network  = NetworkService()
    @State var res: DetailGame? = nil
    @State var isLoading = true
    var body: some View {
        ScrollView(showsIndicators:false){
            if isLoading{
                Text("Loading data...").padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height,alignment: .center)
            }else{
                if let game = myGames{
                    VStack(alignment:.leading,spacing: 5){
                        OnlineImage(url: game.bgImage).padding(.horizontal,15)
                        HStack{
                            VStack(alignment:.leading,spacing:10){
                                HStack{
                                    LoveButton(isLove: $isLove,game: game, gameProvider:gameProvider)
                                    Text(game.name).font(.title3).fontWeight(.semibold)
                                }
                                Text("Released date: \(game.released ?? "N/A")").fontWeight(.light)
                                
                            }
                            Spacer()
                            VStack(alignment:.center,spacing:10){
                                Image(systemName: "star.fill")
                                Text(String(format: "%.2f", game.rating))
                                
                            }
                        }
                        .padding(15)
                        Text("Description").font(.title3).fontWeight(.semibold).padding(.horizontal,15)
                        Text(game.description).padding(15).multilineTextAlignment(.leading)
                        if !game.genres.isEmpty{
                            Text("Genres").font(.title3).fontWeight(.semibold).padding(.horizontal,15)
                            ListGenres(list: game.genres)
                        }
                    }
                    
                }
            }
            
        }
        .onAppear{
            Task{
                isLoading = true
                do {
                    self.myGames = try await network.getDetail(id:"\(gameId)")
                    isLoading = false
                } catch {
                    isLoading = false
                    print("Error")
                }
                gameProvider.isFavorite(gameId) { isFav in
                    DispatchQueue.main.async{
                        isLove=isFav
                        print("isfavvv",isFav)
                    }
                }
                
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .topLeading)
        .background{
            LinearGradient(gradient: Gradient(colors: [.maroon, .darkPurple,.darkPurple2,.darkPurple3]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        }
    }
}

struct ListGenres:View{
    let list:[Genre]
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing:15){
                ForEach(list){i in
                    VStack(spacing:10){
                        OnlineImage(url: i.image_background,width: 80,height: 80)
                        Text(i.name).font(.footnote).fontWeight(.light)
                        
                    }
                }
            }.padding(15)
        }
    }
}

struct ListScreenshot:View{
    let list:[Screenshot]
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing:15){
                ForEach(list){i in
                    OnlineImage(url: i.image,width: 200,height: 150)
                }
            }.padding(15)
        }
    }
}

struct LoveButton: View {
    @Binding var isLove: Bool
    let game: DetailGame
    let gameProvider: GameProvider
    var body: some View {
        Button(action: {
            self.isLove.toggle()
            if isLove {
                saveToFavorites(game: game,gameProvider: gameProvider)
            } else {
                removeFromFavorites(id: game.id,gameProvider: gameProvider)
            }
        }) {
            Image(systemName: isLove ? "heart.fill" : "heart")
        }
    }
}


private func saveToFavorites(game:DetailGame, gameProvider:GameProvider) {
    gameProvider.favGame(gameMapper(game: game)){
        DispatchQueue.main.async {
            print("Saved")
        }
    }
}

private func removeFromFavorites(id:Int, gameProvider:GameProvider) {
    gameProvider.deleteFav(id) {
        DispatchQueue.main.async {
            print("removed")
        }
    }
}

func gameMapper(game:DetailGame)->FavGame{
    return FavGame(
        id:game.id,
        name: game.name,
        released: game.released,
        bgImage: game.bgImage,
        rating:game.rating
    )
}
