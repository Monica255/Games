//
//  HomeView.swift
//  Games
//
//  Created by Monica Sucianto on 25/12/23.
//

import SwiftUI
struct HomeView: View {
    
    init() {
//      UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        let navbar = UINavigationBarAppearance()
        navbar.configureWithOpaqueBackground()
        navbar.backgroundImage = UIImage()
        navbar.backgroundColor = UIColor.clear
        navbar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navbar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let navbar2 = UINavigationBarAppearance()
        navbar2.configureWithOpaqueBackground()
        navbar2.backgroundImage = UIImage()
        navbar2.backgroundColor = UIColor.darkPurple3.withAlphaComponent(0.4)
        navbar2.titleTextAttributes = [.foregroundColor: UIColor.white]
        navbar2.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = navbar2
        UINavigationBar.appearance().scrollEdgeAppearance = navbar
    }

    @State var selection = 0
    public let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    @StateObject var network  = NetworkService()

    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){
                        TabView(selection : $selection){
                            ForEach(network.games.indices, id: \.self) { index in
                                TopGameViewCell(game: network.games[index])
                                    .tag(index)}
                            
                        }.onAppear{
                            network.fetchData(ordering: "-rating")
                        }
                        .padding(.horizontal,15)
                        .frame(height: 200)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        .onReceive(timer, perform: { _ in
                            withAnimation{
                                selection = selection < network.games.count ? selection + 1 : 0
                            }
                        })
                    Text("New Update").font(.title3).padding(15).foregroundColor(.white)
                    HorizontalList(list: network.games3)
                        .onAppear{
                            network.fetchData(ordering:"-updated")
                        }
                    Text("New Added").font(.title3).padding(15).foregroundColor(.white)
                    HorizontalList(list: network.games2)
                        .onAppear{
                            network.fetchData(ordering:"-added")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading)
            .background{
                LinearGradient(gradient: Gradient(colors: [.maroon, .darkPurple,.darkPurple2,.darkPurple3]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            }
            .navigationTitle("Games")
            
        }
    }
}



struct HorizontalList:View{
    @State private var isShowingDetailsView : Bool = false
    let list:[Game]
    var body: some View{
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing:15){
                ForEach(list){game in
                    NavigationStack{
                        GameViewCell(game: game)
                            .navigationDestination(isPresented: $isShowingDetailsView) {
                                DetailView(gameId: game.id)
                            }
                        
                    }
                }
            }.padding(.horizontal,15)
        }
    }
}

struct GameViewCell: View {
    var game:Game
    var body: some View {
        NavigationLink(destination: DetailView(gameId: game.id)){
            ZStack(alignment: .bottomLeading) {
                OnlineImage(url: game.bgImage,width: 150,height: 200)
                VStack{
                    
                    Spacer()
                    VStack(alignment:.leading){
                        Text(game.name)
                        if let releasedDate = game.released {
                            Text(releasedDate).fontWeight(.light).font(.caption)
                        }
                        if game.rating > 0.0 {
                            HStack{
                                Image(systemName: "star.fill")
                                Text(String(format: "%.2f", game.rating))
                            }
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: 150, maxHeight: 80, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.lightGrey.opacity(0.6)))
                    .shadow(radius: 2)
                    
                }.foregroundColor(.white)
            }
            
        }
        
    }
}

struct TopGameViewCell: View {
    var game:Game
    var body: some View {
        NavigationLink(destination: DetailView(gameId: game.id)){
            ZStack(alignment: .topLeading) {
                OnlineImage(url: game.bgImage)
                
                Text(game.name)
                    .lineLimit(1)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.lightGrey.opacity(0.5)))
                    .shadow(radius: 2)
            }
            .foregroundColor(.white)
            
        }
    }
}

struct OnlineImage: View {
    let url: String
    let width: CGFloat
    let height: CGFloat

    @State private var data: Data?

    init(url: String, width: CGFloat = .infinity, height: CGFloat = 200) {
        self.url = url
        self.width = width
        self.height = height
    }

    var body: some View {
        GeometryReader { geometry in
            if let data = data, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .background(Color.white)
                    .cornerRadius(15)
                    .clipped()
            } else {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .background(Color.white)
                    .cornerRadius(15)
                    .clipped()
                    .onAppear {
                        getImage()
                    }
            }
        }
        .frame(width: width, height: height)
    }

    private func getImage() {
        guard let url = URL(string: url) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.data = data
        }

        task.resume()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
