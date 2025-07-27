//
//  ContentView.swift
//  Dex
//
//  Created by Aravind vallabhaneni on 26/07/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest<Pokemon>(
        sortDescriptors: [SortDescriptor(\.id)],
        animation: .default
    ) private var pokedex

    let fetcher = FetchService()
    
  @State private var searchText: String = ""
    
    private var DynamicPredicate: NSPredicate {
        var predicate: [NSPredicate] = []
        
        // predicate for the search text
        
        if !searchText.isEmpty {
            predicate.append(NSPredicate(format: "name contains[c] %@" ,searchText))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
    }
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                            
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        VStack(alignment: .leading) {
                            Text(pokemon.name!.capitalized)
                                .fontWeight(.bold)
                            
                            HStack {
                                ForEach(pokemon.types!, id: \.self) { type in
                                    Text(type)
                                        .fontWeight(.semibold)
                                        .font(.subheadline)
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 13)
                                        .padding(.vertical, 5)
                                        .background(Color(type.capitalized))
                                        .clipShape(.capsule)
                                        
                                }
                            }
                        }
                    }
                }
               
            }
            .navigationTitle("Pokedex")
            .searchable(text: $searchText, prompt: "find a pokemon")
            .onChange(of: searchText){
                pokedex.nsPredicate = DynamicPredicate
            }
            .navigationDestination(for: Pokemon.self) { pokemon in
                Text(pokemon.name!)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        getPokemon()
                    }
                }
            }
        }
    }

    
    private func getPokemon() {
        
        Task {
            for id in 1..<152 {
                do {
                  let fetchedPokemon = try await fetcher.fetchPokemon(id)
                    
                    let pokemon = Pokemon(context: viewContext)
                    
                    pokemon.id = fetchedPokemon.id
                    pokemon.name = fetchedPokemon.name
                    pokemon.attack = fetchedPokemon.attack
                    pokemon.defense = fetchedPokemon.defense
                    pokemon.speed = fetchedPokemon.speed
                    pokemon.shiny = fetchedPokemon.shiny
                    pokemon.specialAttack = fetchedPokemon.specialAttack
                    pokemon.specialDefense = fetchedPokemon.specialDefense
                    pokemon.sprite = fetchedPokemon.sprite
                    pokemon.hp = fetchedPokemon.hp
                    pokemon.types = fetchedPokemon.types
                    
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }

}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
