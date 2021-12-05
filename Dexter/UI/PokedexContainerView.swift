//
//  PokedexContainerView.swift
//  Dexter
//
//  Created by Jacob Bartlett on 28/11/2021.
//

import SwiftUI

struct PokedexContainerView: View {
    
    @EnvironmentObject private var viewModel: PokedexViewModel
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    Text("Pokédex")
                        .font(.system(.largeTitle).monospaced())
                        .bold()
                        .foregroundColor(.yellow)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(.horizontal)
                
                    Group {
                        if let pokemon = viewModel.selectedPokemon {
                            PokemonView(animation: animation, pokemon: pokemon)
                            
                        } else {
                            PokedexView(animation: animation)
                        }
                    }
                }
            }
        }
    }
}

struct PokedexContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexContainerView()
    }
}
