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
    
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.backgroundImage)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 7)
                
                AsyncImage(url: pokemon.sprite) { image in
                    image
                        .interpolation(.none)
                        .resizable()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 7)
                } placeholder: {
                    ProgressView()
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
    }
}

#Preview {
    NavigationStack {
        PokemonDetail()
            .environmentObject(PersistenceController.previewPokemon)
    }
}
