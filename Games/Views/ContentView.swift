//
//  ContentView.swift
//  Games
//
//  Created by Monica Sucianto on 25/12/23.
//

import SwiftUI

struct ContentView: View {
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundImage = UIImage()
        tabBarAppearance.backgroundColor = UIColor.darkPurple3.withAlphaComponent(0.75)
    
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Games", systemImage: "gamecontroller.fill")
                }
            SearchView()
                .tabItem {
                    Label("Profile", systemImage: "magnifyingglass")
                }
            ListFavorite()
                .tabItem {
                    Label("Favorite", systemImage: "heart.circle.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}


#Preview {
    ContentView()
}
