//
//  PokedexNetworking.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import Combine
import Foundation
import SwiftUI

protocol PokedexNetworking {
    var session: URLSession { get }
}

extension PokedexNetworking {
    
    func listPokemon() -> AnyPublisher<PokemonResult, Error> {
        PokemonURLRequestPool.listPokemon.request()
            .flatMap { session.readPublisher($0, responseType: PokemonResult.self) }
            .eraseToAnyPublisher()
    }
    
    func readPokemon(id: Int) -> AnyPublisher<PokemonDetails, Error> {
        PokemonURLRequestPool.readPokemonDetails(id).request()
            .flatMap { session.readPublisher($0, responseType: PokemonDetails.self) }
            .eraseToAnyPublisher()
    }

    /// This API doens't really work because PokéAPI is read-only
    /// It's used illustratively to show how to send writes to your API
    func update(pokemon: PokemonDetails) -> AnyPublisher<Void, Error> {
        Just(pokemon)
            .encode(encoder: JSONEncoder())
            .flatMap { PokemonURLRequestPool.updatePokemon(pokemon.id).request(data: $0) }
            .flatMap { session.writePublisher($0) }
            .eraseToAnyPublisher()
    }
}
