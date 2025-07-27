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
  @State private var favorites: Bool = false
    private var DynamicPredicate: NSPredicate {
        var predicate: [NSPredicate] = []
        
        // predicate for the search text
        
        if !searchText.isEmpty {
            predicate.append(NSPredicate(format: "name contains[c] %@" ,searchText))
        }
        
        if favorites {
            predicate.append(NSPredicate(format: "favorite == %d", true))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
    }
    
    var body: some View {
        if pokedex.isEmpty {
            ContentUnavailableView {
                Label("Missing Pokemon", image: .nopokemon)
            } description: {
                Text("There aren't any pokemons yet.\nFetch some pokemons to get started!")
            } actions: {
                Button("Fetch Pokemon", systemImage: "antenna.radiowaves.left.and.right") {
                    getPokemon(from: 1)
                }
                .buttonStyle(.borderedProminent)
            }
            
        } else {
            NavigationStack{
                List {
                    Section {
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
                                    HStack {
                                        Text(pokemon.name!.capitalized)
                                            .fontWeight(.bold)
                                        
                                        if pokemon.favorite {
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(.yellow)
                                        }
                                    }
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
                    } footer: {
                        
                        if pokedex.count < 151 {
                            ContentUnavailableView {
                                Label("Missing Pokemon", image: .nopokemon)
                            } description: {
                                Text("The fetch was interrupted!\nFetch rest of the pokemons.")
                            } actions: {
                                Button("Fetch Pokemon",  systemImage: "antenna.radiowaves.left.and.right") {
                                    getPokemon(from: pokedex.count + 1)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .searchable(text: $searchText, prompt: "find a pokemon")
                .autocorrectionDisabled()
                .onChange(of: searchText){
                    pokedex.nsPredicate = DynamicPredicate
                }
                .onChange(of: favorites) {
                    pokedex.nsPredicate = DynamicPredicate
                }
                .navigationDestination(for: Pokemon.self) { pokemon in
                    Text(pokemon.name!)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            favorites.toggle()
                        } label: {
                            Label("favorites", systemImage: favorites ? "star.fill" : "star")
                        }
                        .tint(.yellow)
                    }
                }
            }
           
        }
    }

    
    private func getPokemon(from id: Int) {
        
        Task {
            for i in id..<152 {
                do {
                  let fetchedPokemon = try await fetcher.fetchPokemon(i)
                    
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
                    
                    if pokemon.id % 2 == 0 {
                        pokemon.favorite = true
                    }
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
