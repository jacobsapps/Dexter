//
//  PokemonURLRequestPool.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import Combine
import Foundation

enum PokemonURLRequestPool: URLRequestPool {
    
    case listPokemon
    case readPokemonDetails(_ id: Int)
    case updatePokemon(_ id: Int)
    
    var endpoint: String {
        switch self {
        case .listPokemon:                return "pokemon?limit=150"
        case .readPokemonDetails(let id): return "pokemon/\(id)"
        case .updatePokemon(let id):      return "pokemon/\(id)"
        }
    }
    
    func method(data: Data?) -> URLRequest.HTTPMethod {
        switch self {
        case .listPokemon:        return .get
        case .readPokemonDetails: return .get
        case .updatePokemon:      return .put(data)
        }
    }
}
