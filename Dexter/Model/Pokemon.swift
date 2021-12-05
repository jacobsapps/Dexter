//
//  Pokemon.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import SwiftUI

struct PokemonResult: Codable {
    
    var pokemon: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case pokemon = "results"
    }
}

struct Pokemon: Codable, Identifiable {
    
    enum CustomDecodingError: Error {
        case url
        case id
    }
    
    var id: Int
    var name: String
    var url: URL
    
    enum CodingKeys: CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name).capitalized
        let urlString = try container.decode(String.self, forKey: .url)
        guard let url = URL(string: urlString) else { throw CustomDecodingError.url }
        self.url = url
        guard let idString = url.pathComponents.last,
        let id = Int(idString) else { throw CustomDecodingError.id }
        self.id = id 
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url.absoluteString, forKey: .url)
    }
}
