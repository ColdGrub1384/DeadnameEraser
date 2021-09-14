//
//  SafariWebExtensionHandler.swift
//  Deadname Eraser Extension
//
//  Created by Emma Labbé on 08-06-21.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
        
        let names = NamesDatabase.shared.names.sorted(by: { $0.deadName.count > $1.deadName.count })
        
        var array = [[String:String]]()
        
        for name in names {
            
            guard !name.deadName.isEmpty else {
                continue
            }
            
            array.append(["deadname": name.deadName, "chosenname": name.currentName])
        }
        
        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: array ]

        context.completeRequest(returningItems: [response], completionHandler: { success in
            exit(success ? 0 : 1)
        })
    }

}
