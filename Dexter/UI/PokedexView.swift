//
//  ContentView.swift
//  Dexter
//
//  Created by Jacob Bartlett on 22/11/2021.
//

import SwiftUI

struct PokedexView: View {
    
    @EnvironmentObject private var viewModel: PokedexViewModel
    var animation: Namespace.ID
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(viewModel.pokemon) { pokemon in
                    pokemonGridItem(with: pokemon)
                        .padding(.bottom, 8)
                }
            }
            .padding(8)
        }
    }
    
    private func pokemonGridItem(with pokemon: Pokemon) -> some View {
        ZStack(alignment: .topLeading) {
            Color.green
            
            ZStack(alignment: .bottom) {
                name(with: pokemon)
                sprite(with: pokemon)
            }
            id(with: pokemon)
        }
        .frame(height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .matchedGeometryEffect(id: "\(pokemon.id).background", in: animation)
        .onTapGesture {
            withAnimation(.spring()) {
                viewModel.selectedPokemon = pokemon
            }
        }
        .onAppear {
            viewModel.fetchSprite(for: pokemon)
        }
        .shadow(color: Color.black.opacity(0.5),
                radius: 3, x: 1, y: 1)
    }
    
    private func sprite(with pokemon: Pokemon) -> some View {
        Image(uiImage: viewModel.sprites[pokemon.id] ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .matchedGeometryEffect(id: "\(pokemon.id).sprite", in: animation)
    }
    
    private func name(with pokemon: Pokemon) -> some View {
        Text(pokemon.name)
            .font(.system(.subheadline).monospaced())
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(Color.black.opacity(0.8))
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(8)
            .matchedGeometryEffect(id: "\(pokemon.id).name", in: animation)
    }
    
    private func id(with pokemon: Pokemon) -> some View {
        Text("#\(pokemon.id)")
            .font(.system(.headline).monospaced())
            .foregroundColor(Color.black.opacity(0.5))
            .padding(8)
    }
}
