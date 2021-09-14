//
//  NamesDatabase.swift
//  Deadname Eraser
//
//  Created by Emma Labbé on 08-06-21.
//

import Combine
import Foundation

class NamesDatabase: ObservableObject {
    
    private static let userDefaults = UserDefaults(suiteName: "group.deadnameremover")
    
    private static func getNamesFromDisk() -> [Name] {
        
        let empty = [Name(deadName: "", currentName: "")]
        
        guard let data = userDefaults?.data(forKey: "names") else {
            return empty
        }
        
        do {
            let names = try JSONDecoder().decode([Name].self, from: data)
            if names.count == 0 {
                return empty
            } else {
                return names
            }
        } catch {
            print(error.localizedDescription)
            return empty
        }
    }
    
    private let savingQueue = DispatchQueue.global()
    
    private init() {}
    
    static let shared = NamesDatabase()
    
    @Published var names = getNamesFromDisk() {
        didSet {
            
            savingQueue.async {
                do {
                    let data = try JSONEncoder().encode(self.names)
                    NamesDatabase.userDefaults?.set(data, forKey: "names")
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            objectWillChange.send()
        }
    }
}
