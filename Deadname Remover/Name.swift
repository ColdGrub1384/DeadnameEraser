//
//  Name.swift
//  Deadname Remover
//
//  Created by Emma Labbé on 08-06-21.
//

import Foundation

struct Name: Identifiable, Codable {
    
    var id = UUID()
    
    var deadName: String
    
    var currentName: String
}
