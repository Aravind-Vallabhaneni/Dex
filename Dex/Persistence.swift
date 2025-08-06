//
//  Persistence.swift
//  Dex
//
//  Created by Aravind vallabhaneni on 26/07/25.
//

import Foundation
import SwiftData

@MainActor
struct PersistenceController {
    static let shared = PersistenceController()

    static var previewPokemon: Pokemon {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let pokemonData = try! Data(contentsOf: Bundle.main.url(forResource: "samplepokemon", withExtension: "json")!)
        
        let pokemon = try! decoder.decode(Pokemon.self, from: pokemonData)
        
        return pokemon
    }
    
    static let preview: ModelContainer = {
        
        let container = try! ModelContainer(for: Pokemon.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        container.mainContext.insert(previewPokemon)
        
        return container
      }()
}
