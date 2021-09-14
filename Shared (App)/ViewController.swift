//
//  ViewController.swift
//  Shared (App)
//
//  Created by Emma Labbé on 29-06-21.
//

import WebKit
import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformViewController = UIViewController
#elseif os(macOS)
import Cocoa
import SafariServices
typealias PlatformViewController = NSViewController

class HostingController: NSHostingController<Configuration> {
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        NSApp.stopModal()
    }
}
#endif

let extensionBundleIdentifier = "ch.ada.Deadname-Remover.Extension"

class ViewController: PlatformViewController, WKNavigationDelegate, WKScriptMessageHandler {

    @IBOutlet var webView: WKWebView!

    #if os(macOS)
    let toolbarDelegate = ToolbarDelegate()
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.navigationDelegate = self

#if os(iOS)
        self.webView.scrollView.isScrollEnabled = false
#endif

        self.webView.configuration.userContentController.add(self, name: "controller")

        self.webView.loadFileURL(Bundle.main.url(forResource: "Main", withExtension: "html")!, allowingReadAccessTo: Bundle.main.resourceURL!)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
#if os(iOS)
        webView.evaluateJavaScript("show('ios')")
#elseif os(macOS)
        webView.evaluateJavaScript("show('mac')")

        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionBundleIdentifier) { (state, error) in
            guard let state = state, error == nil else {
                // Insert code to inform the user that something went wrong.
                return
            }

            DispatchQueue.main.async {
                webView.evaluateJavaScript("show('mac', \(state.isEnabled)")
            }
        }
#endif
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if (message.body as? String) == "configure" {
            #if os(iOS)
            let vc = UIHostingController(rootView: Configuration(dismiss: {
                self.dismiss(animated: true, completion: nil)
            }))
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true, completion: nil)
            #else
            
            let vc = HostingController(rootView: Configuration(dismiss: {
                self.dismiss(nil)
            }))
            
            vc.title = "Configuration"
           
            vc.preferredContentSize = NSSize(width: 500, height: 300)
            
            let window = NSWindow(contentViewController: vc)
            window.toolbar = NSToolbar(identifier: "ConfigToolbar")
            window.toolbar?.delegate = toolbarDelegate
            window.toolbar?.insertItem(withItemIdentifier: .init(rawValue: "Add"), at: 0)
            
            view.window?.beginSheet(window, completionHandler: nil)
            #endif
        }
        
#if os(macOS)
        if (message.body as! String != "open-preferences") {
            return
        }

        SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionBundleIdentifier) { error in
            print(error?.localizedDescription.appending("\n") ?? "", terminator: "")
        }
#endif
    }

}
