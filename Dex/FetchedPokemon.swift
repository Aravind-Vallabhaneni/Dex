//
//  FetchedPokemon.swift
//  Dex
//
//  Created by Aravind vallabhaneni on 27/07/25.
//


import Foundation

struct FetchedPokemon: Decodable {
    
    let id: Int16
    let name: String
    let types: [String]
    let hp: Int16
    let attack: Int16
    let defense: Int16
    let specialAttack: Int16
    let specialDefense: Int16
    let speed: Int16
    let spriteURL: URL
    let shinyURL: URL
    
    
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
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int16.self, forKey: .id)
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
        
        var stats: [Int16] = []
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        while !statsContainer.isAtEnd {
            let statsValueContainer = try statsContainer.nestedContainer(keyedBy: CodingKeys.StatDictionaryKeys.self)
            
            let stat = try statsValueContainer.decode(Int16.self, forKey: .baseStat)
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
