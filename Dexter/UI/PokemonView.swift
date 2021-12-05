//
//  PokemonView.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import SwiftUI

struct PokemonView: View {
    
    @EnvironmentObject private var viewModel: PokedexViewModel
    var animation: Namespace.ID
    var pokemon: Pokemon
    @State private var showAttributes: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                sprite
                name
                    .padding(.vertical, 12)
                if showAttributes {
                    attributesList
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                Spacer()
            }
            backButton
        }
        .padding(.horizontal, 8)
        .frame(maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.green))
        .clipped()
        .matchedGeometryEffect(id: "\(pokemon.id).background", in: animation)
        .shadow(color: Color.black.opacity(0.5),
                radius: 3, x: 1, y: 1)
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                withAnimation {
                    showAttributes = true
                }
            })
        }
    }
    
    private var sprite: some View {
        Image(uiImage: viewModel.sprites[pokemon.id] ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: .infinity)
            .matchedGeometryEffect(id: "\(pokemon.id).sprite", in: animation)
    }
    
    private var name: some View {
        Text(pokemon.name)
            .font(.system(.headline).monospaced())
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(Color.black.opacity(0.8))
            .frame(maxWidth: .infinity, alignment: .center)
            .matchedGeometryEffect(id: "\(pokemon.id).name", in: animation)
    }
    
    private var attributesList: some View {
        VStack(spacing: 0) {
            attribute("Pokedex no.", "\(viewModel.pokemonDetails?.order ?? 0)")
            attribute("Type #1", "\(viewModel.pokemonDetails?.types.first?.type.name.capitalized ?? "n/a")")
            attribute("Type #2", "\(viewModel.pokemonDetails?.types.dropFirst().first?.type.name.capitalized ?? "n/a")")
            attribute("Height", "\(viewModel.pokemonDetails?.height  ?? 0)in")
            attribute("Weight", "\(viewModel.pokemonDetails?.weight ?? 0)lbs")
        }
    }
    
    private func attribute(_ attributeName: String, _ attributeValue: String) -> some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Text(attributeName)
                    .font(.system(.body).monospaced())
                    .foregroundColor(Color.black.opacity(0.8))
                
                Spacer()
                
                Text(attributeValue)
                    .font(.system(.body).monospaced())
                    .foregroundColor(Color.black)
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
    
    private var backButton: some View {
        Button(action: {
            withAnimation {
                viewModel.pokemonDetails = nil
                viewModel.selectedPokemon = nil
            }
            
        }, label: {
            Text("Back")
                .font(.system(.body).monospaced())
                .bold()
                .foregroundColor(.yellow)
                .padding()
                .contentShape(Rectangle())
        })
    }
}
