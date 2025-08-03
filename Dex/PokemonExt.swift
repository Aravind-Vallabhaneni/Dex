//
//  PokemonExt.swift
//  Dex
//
//  Created by Aravind vallabhaneni on 03/08/25.
//

import SwiftUI

extension Pokemon {
    
    var backgroundImage: ImageResource {
        
        switch types![0] {
        
        case "rock", "ground", "steel", "fighthing", "ghost", "dark", "psyhic":
                .rockgroundsteelfightingghostdarkpsychic
            
        case "fire","dragon":
                .firedragon
        
        case "flying","bug":
                .flyingbug
            
        case "ice":
                .ice
            
        case "water":
                .water
            
        default:
                .normalgrasselectricpoisonfairy
            
        }
    }
    
    var typeColor: Color {
        Color(types![0].capitalized)
    }
    
    var stats: [stat] {
        [
            stat(id: 1, name: "Hp", value: hp),
            stat(id: 2, name: "Attack", value: attack),
            stat(id: 3, name: "Defense", value: defense),
            stat(id: 4, name: "Special Attack", value: specialAttack),
            stat(id: 5, name: "Special Defense", value: specialDefense),
            stat(id: 6, name: "Speed", value: speed)
        ]
    }
    
    var highestStat: stat {
        
        stats.max {$0.value < $1.value }!
        
    }
}

struct stat: Identifiable {
    var id: Int
    var name: String
    var value: Int16
}
