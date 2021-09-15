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
        
        if let names = message as? [[String:String]] {
            NamesDatabase.shared.names = names.map({ Name(deadName: $0["deadname"] ?? "", currentName: $0["chosenname"] ?? "") })
            
            context.completeRequest(returningItems: [], completionHandler: { success in
                exit(success ? 0 : 1)
            })
        } else {
            let names = NamesDatabase.shared.names.sorted(by: { $0.deadName.count > $1.deadName.count })
            
            var array = [[String:String]]()
            
            for name in names {
                array.append(["deadname": name.deadName, "chosenname": name.currentName])
            }
            
            let response = NSExtensionItem()
            response.userInfo = [ SFExtensionMessageKey: array ]

            context.completeRequest(returningItems: [response], completionHandler: { success in
                exit(success ? 0 : 1)
            })
        }
    }

}
