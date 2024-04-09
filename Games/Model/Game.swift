//
//  Game.swift
//  Games
//
//  Created by Monica Sucianto on 25/12/23.
//

import Foundation

struct Game : Identifiable, Codable, Equatable{
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
    let id: Int
    let name: String
    let released: String?
    let bgImage: String
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case bgImage = "background_image"
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let backgroundImage = try? container.decode(String.self, forKey: .bgImage) {
            self.bgImage = backgroundImage
        } else {
            self.bgImage = ""
        }
        
        name = try container.decode(String.self, forKey: .name)
        released = try container.decodeIfPresent(String.self, forKey: .released) ?? "N/A"
        rating = try container.decode(Double.self, forKey: .rating)
        id = try container.decode(Int.self, forKey: .id)
    }
}

struct DetailGame:Identifiable, Codable, Equatable{
    static func == (lhs: DetailGame, rhs: DetailGame) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let released: String?
    let bgImage: String
    let rating: Double
    let genres: [Genre]
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case bgImage = "background_image"
        case rating
        case genres
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let backgroundImage = try? container.decode(String.self, forKey: .bgImage) {
            self.bgImage = backgroundImage
        } else {
            self.bgImage = ""
        }
        
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        released = try container.decodeIfPresent(String.self, forKey: .released) ?? "N/A"
        genres = try container.decode([Genre].self, forKey: .genres)
        rating = try container.decode(Double.self, forKey: .rating)
        id = try container.decode(Int.self, forKey: .id)
    }
}


struct Genre: Identifiable, Codable{
    let id: Int
    let name: String
    let image_background: String
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        if let backgroundImage = try? container.decode(String.self, forKey: .image_background) {
            self.image_background = backgroundImage
        } else {
            self.image_background = "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Fvector-art%2F9007134-failed-to-load-page-concept-illustration-flat-design-vector-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon&psig=AOvVaw16gATcWbsBPY8-M9uk5i5O&ust=1703670892021000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCLjV1uvqrIMDFQAAAAAdAAAAABAD"
        }
    }
}

struct Screenshot:Identifiable, Codable, Hashable{
    var id: Int
    var image: String
}


struct FavGame: Codable, Identifiable{
    let id: Int
    let name: String?
    let released: String?
    let bgImage: String?
    let rating: Double?
}

