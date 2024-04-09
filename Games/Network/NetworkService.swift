//
//  NetworkService.swift
//  Games
//
//  Created by Monica Sucianto on 26/12/23.
//

import Foundation

class NetworkService: ObservableObject {
    @Published var games: [Game] = []
    @Published var games2: [Game] = []
    @Published var games3: [Game] = []
    @Published var games4: [Game] = []
    @Published var searchedGame: DetailGame? = nil
    let key = "dd134223b22245e19bd668f22e981f03"
    let page = "1"
    
    func getDetail(id: String = "") async throws -> DetailGame{
        var components = URLComponents(string: "https://api.rawg.io/api/games/\(id)")!
        var queryItems = [
            URLQueryItem(name: "key", value: key),
        ]
        
        
        components.queryItems = queryItems
        let request = URLRequest(url: components.url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error: Can't fetching data.")
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(DetailGame.self, from: data)
        
        return result
    }
    
    func fetchData(ordering: String = "",query: String="",pageSize: String="5",id: String = "") {
        var components = URLComponents(string: "https://api.rawg.io/api/games")!
        var queryItems = [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "page_size", value: pageSize),
            URLQueryItem(name: "page", value: page),
        ]
        
        if !query.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: query))
        }
        if !ordering.isEmpty {
            queryItems.append(URLQueryItem(name: "ordering", value: ordering))
        }
        
        components.queryItems = queryItems
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Response.self, from: data)
                
                DispatchQueue.main.async {
                    switch(ordering){
                    case "-rating":self?.games = result.results
                    case "-added":self?.games2 = result.results
                    case "-updated":self?.games3 = result.results
                    default:
                        self?.games4 = result.results
                    }
                    
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
}

