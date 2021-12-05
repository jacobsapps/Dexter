//
//  DexterApp.swift
//  Dexter
//
//  Created by Jacob Bartlett on 22/11/2021.
//

import SwiftUI

@main
struct DexterApp: App {
    var body: some Scene {
        WindowGroup {
            PokedexContainerView()
                .environmentObject(PokedexViewModel())
        }
    }
}
