//
//  Name.swift
//  Deadname Eraser
//
//  Created by Emma Labbé on 08-06-21.
//

import Foundation

struct Name: Identifiable, Codable, Hashable {
    
    var id = UUID()
    
    var deadName: String
    
    var currentName: String    
}
