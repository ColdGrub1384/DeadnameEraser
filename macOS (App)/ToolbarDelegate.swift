//
//  ToolbarDelegate.swift
//  Deadname Remover (macOS)
//
//  Created by Emma Labbé on 30-06-21.
//

import AppKit

class ToolbarDelegate: NSObject, NSToolbarDelegate {
    
    @objc func addName() {
        NotificationCenter.default.post(name: .init(rawValue: "Add"), object: UUID())
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.init(rawValue: "Add")]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [.init(rawValue: "Add")]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        let item = NSToolbarItem(itemIdentifier: .init(rawValue: "Add"))
        item.image = NSImage(named: NSImage.addTemplateName)
        item.target = self
        item.action = #selector(addName)
        
        return item
    }
}
