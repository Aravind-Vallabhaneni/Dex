//
//  PokemonDetail.swift
//  Dex
//
//  Created by Aravind vallabhaneni on 28/07/25.
//

import SwiftUI

struct PokemonDetail: View {
    @Environment(\.managedObjectContext) private var viewContext

    @EnvironmentObject private var pokemon: Pokemon
    @State private var isFavorite: Bool = false
    @State private var showShiny: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.backgroundImage)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 7)
                
                if pokemon.sprite == nil || pokemon.shiny == nil {
                    AsyncImage(url: showShiny ? pokemon.shinyURL : pokemon.spriteURL) { image in
                        image
                            .interpolation(.none)
                            .resizable()
                            .padding(.top, 50)
                            .shadow(color: .black, radius: 7)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    (showShiny ? pokemon.shinyImage : pokemon.spriteImage)
                }
            }
            HStack {
                ForEach(pokemon.types!, id:\.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .shadow(color: .white, radius: 1)
                        .padding(.vertical, 7)
                        .padding(.horizontal)
                        .background(Color(type.capitalized))
                        .clipShape(.capsule)
                }
                Spacer()
                
                Button {
                    pokemon.favorite.toggle()
                    
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                } label: {
                    Image(systemName: pokemon.favorite ? "star.fill" : "star")
                        .font(.largeTitle)
                        .tint(.yellow)
                }
            }
            .padding()
            
            Text("Stats")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, -7)
            
            Stats(pokemon: pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    showShiny.toggle()
                } label: {
                    Image(systemName: showShiny ? "wand.and.stars" : "wand.and.stars.inverse")
                        .tint(showShiny ? .yellow : .primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetail()
            .environmentObject(PersistenceController.previewPokemon)
    }
}
