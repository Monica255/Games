//
//  Response.swift
//  Games
//
//  Created by Monica Sucianto on 26/12/23.
//

import Foundation


struct Response: Decodable{
    let count: Int?
    let results: [Game]
    enum CodingKeys: CodingKey {
        case count
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decodeIfPresent(Int.self, forKey: .count)
        self.results = try container.decode([Game].self, forKey: .results)
    }
}
