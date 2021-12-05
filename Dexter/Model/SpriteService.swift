//
//  SpriteService.swift
//  Dexter
//
//  Created by Jacob Bartlett on 28/11/2021.
//

import Combine
import UIKit

struct SpriteService {
    
    private(set) var spriteCache = Cache<Int, Data>()
    
    func spritePublisher(for pokemon: Pokemon) -> AnyPublisher<UIImage, Never> {
        
        if let cachedItem = spriteCache[pokemon.id] {
            return Just(UIImage(data: cachedItem) ?? UIImage())
                .eraseToAnyPublisher()
            
        } else {
            return pokemon.spriteURL
                .flatMap { URLSession.shared.dataTaskPublisher(for: $0).mapError { $0 as Error } }
                .map {
                    spriteCache[pokemon.id] = $0.data
                    return UIImage(data: $0.data) ?? UIImage()
                }
                .replaceError(with: UIImage())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
    }
}

extension Pokemon {
    
    var spriteURL: AnyPublisher<URL, Error> {
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png") else { return Fail(error: URLSession.NetworkError.invalidURL).eraseToAnyPublisher() }
        return Just(url)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
