//
//  PokedexViewModel.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import Combine
import Foundation
import UIKit

final class PokedexViewModel: ObservableObject, PokedexNetworking {
    
    private var subscription: AnyCancellable?
    private var subscriptions = Set<AnyCancellable>()
    var session: URLSession
    private let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=150") // used in simple demo 
    private let spriteService = SpriteService()
    
    @Published private(set) var pokemon: [Pokemon] = []

    @Published var sprites = [Int: UIImage]()
    @Published var selectedPokemon: Pokemon? {
        didSet {
            readPokemonDetails()
        }
    }
    @Published private(set) var errorMessage: String?
    @Published var pokemonDetails: PokemonDetails?
    
    /// Initialize with a custom URLSession using URLProtocol to enable easy unit testing
    /// Initialize with `showSimpleExample = true` to use the non-refactored version where all the logic lives in the view model
    init(session: URLSession = .shared, showSimpleExample: Bool = false) {
        self.session = session
        
        if showSimpleExample {
            fetchPokemon()
            
        } else {
            configureSubscribers()
        }
    }
    
    private func configureSubscribers() {
        listPokemon()
            .sink(receiveCompletion: { [weak self] in
                if case .failure(let error) = $0 {
                    self?.errorMessage = error.localizedDescription
                }

            }, receiveValue: { [weak self] in
                self?.pokemon = $0.pokemon
            })
            .store(in: &subscriptions)
    }
    
    func fetchSprite(for pokemon: Pokemon) {
        spriteService.spritePublisher(for: pokemon)
            .sink(receiveValue: { [weak self] in
                self?.sprites[pokemon.id] = $0
            })
            .store(in: &subscriptions)
    }
    
    private func readPokemonDetails() {
        guard let id = selectedPokemon?.id else { return }
        readPokemon(id: id)
            .sinkNetworkRequest({ [weak self] in
                self?.pokemonDetails = $0
            }, store: &subscriptions)
    }
    
    /// Non-refactored version with all the Combine logic in one place
    private func fetchPokemon() {
        guard let url = url else { return }
        Just(url)
            .flatMap { URLSession.shared.dataTaskPublisher(for: $0) }
            .tryMap { element -> Data in
                guard (element.response as? HTTPURLResponse)?.statusCode == 200 else { throw NSError() }
                return element.data
            }
            .decode(type: PokemonResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                if case .failure(let error) = $0 {
                    print(error.localizedDescription)
                }
                
            }, receiveValue: { [weak self] in
                self?.pokemon = $0.pokemon
            })
            .store(in: &subscriptions)
    }
}
