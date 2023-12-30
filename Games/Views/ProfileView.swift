//
//  ProfileView.swift
//  Games
//
//  Created by Monica Sucianto on 25/12/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing:12){
            Image("profile image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(15)
            Text("Profile")
                .padding(12)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.darkGrey.opacity(0.7))  // Set the fill color here
                ).shadow(radius: 2)
                
                
            VStack{
                DataItem(label: "Name", content: "Monica")
                DataItem(label: "Email", content: "monicasucianto123@gmail.com")
                DataItem(label: "Join date", content: "2023 - 12 - 12")
                DataItem(label: "Gender", content: "Female")
                DataItem(label: "Country", content: "Indonesia")
                DataItem(label: "City", content: "Makassar")
            }.padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.darkGrey.opacity(0.5))  // Set the fill color here
            )
            .shadow(radius: 2)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            LinearGradient(gradient: Gradient(colors: [.maroon, .darkPurple,.darkPurple2,.darkPurple3]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
    }
}

struct DataItem:View{
    var label: String
    var content: String
    var body: some View{
        HStack{
            Text(label).foregroundColor(.white).fontWeight(.semibold).font(.subheadline)
            Spacer()
            Text(content).foregroundColor(.white).fontWeight(.light).font(.subheadline)
            
        }.padding(12).overlay(Rectangle().stroke(.black,lineWidth: 1))
    }
}

#Preview {
    ProfileView()
}
