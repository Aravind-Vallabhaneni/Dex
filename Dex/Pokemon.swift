//
//  Pokemon.swift
//  Dex
//
//  Created by Aravind vallabhaneni on 06/08/25.
//
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Pokemon: Decodable {
    
    @Attribute(.unique) var id: Int
    var attack: Int
    var defense: Int
    var favorite: Bool = false
    var hp: Int
    var name: String
    var shiny: Data?
    var shinyURL: URL
    var specialAttack: Int
    var specialDefense: Int
    var speed: Int
    var sprite: Data?
    var spriteURL: URL
    var types: [String]
    
    var backgroundImage: ImageResource {
        
        switch types[0] {
            
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
        Color(types[0].capitalized)
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
    
    var spriteImage: Image {
        if let data = sprite, let image = UIImage(data: data) {
            Image(uiImage: image)
        } else {
            Image(.bulbasaur)
        }
    }
    
    var shinyImage: Image {
        if let data = shiny, let image = UIImage(data: data) {
            Image(uiImage: image)
        } else {
            Image(.shinybulbasaur)
        }
    }
    
    struct stat: Identifiable {
        var id: Int
        var name: String
        var value: Int
    }

    
    enum CodingKeys: CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        
        
        enum TypeDictionaryKeys: CodingKey {
            case type
            
            enum Typekeys: CodingKey {
                case name
            }
        }
        
        
        
        enum StatDictionaryKeys: CodingKey {
            case baseStat
        }
        
        enum SpriteKeys: String,CodingKey {
            case spriteURL = "frontDefault"
            case shinyURL = "frontShiny"
        }
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        var tempTypes: [String] = []
        var typesContainer = try container.nestedUnkeyedContainer(forKey: .types)
        while !typesContainer.isAtEnd {
            let typeDictionaryContainer = try typesContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.self)
            let typekeys = try typeDictionaryContainer.nestedContainer(keyedBy: CodingKeys.TypeDictionaryKeys.Typekeys.self, forKey: .type)
            
            let type = try typekeys.decode(String.self, forKey: .name)
            tempTypes.append(type)
        }
        
        if tempTypes.count == 2 && tempTypes[0] == "normal" {
            tempTypes.swapAt(0, 1)
        }
        
        types = tempTypes
        
        var stats: [Int] = []
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsValueContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            
            let stat = try statsValueContainer.decode(Int.self, forKey: .baseStat)
            stats.append(stat)
        }
        hp = stats[0]
        attack = stats[1]
        defense = stats[2]
        specialAttack = stats[3]
        specialDefense = stats[4]
        speed = stats[5]
        
        let spritesContainer = try container.nestedContainer(keyedBy: CodingKeys.SpriteKeys.self, forKey: .sprites)
        spriteURL = try spritesContainer.decode(URL.self, forKey: .spriteURL)
        shinyURL = try spritesContainer.decode(URL.self, forKey: .shinyURL)
    }
    
}
