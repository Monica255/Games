//
//  HomeView.swift
//  Games
//
//  Created by Monica Sucianto on 25/12/23.
//

import SwiftUI

struct HomeView: View {
    init() {
      UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    @State var showView = false
    var body: some View {
        NavigationView {
            VStack{
                Text("Hello, World!")
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background{
                LinearGradient(gradient: Gradient(colors: [.maroon, .darkPurple,.darkPurple2,.darkPurple3]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
            .navigationTitle("Games")
            .foregroundColor(.white)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
