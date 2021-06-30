//
//  Configuration.swift
//  Deadname Remover
//
//  Created by Emma Labbé on 08-06-21.
//

import SwiftUI

#if os(macOS)

struct DoneButton: NSViewRepresentable {

    class Done: NSObject {
        
        static let shared = Done()
        
        @objc func done() {
            NSApp.keyWindow?.close()
        }
    }
        
    func makeNSView(context: Context) -> some NSView {
        let button = NSButton(title: "Done", target: Done.shared, action: #selector(Done.done))
        
        button.state = .on
        button.bezelStyle = .rounded
        button.setButtonType(.onOff)
        
        return button
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
#endif

fileprivate var cachedIds = [UUID]()

struct Configuration: View {
    
    @ObservedObject var namesDatabase = NamesDatabase.shared
    
    var dismiss: (() -> Void)
    
    let footer = Text("Type every variant of the name that you previously used so the web extension can replace it. Case doesn't matter. You can add your firstname and lastname together or you can just write your firstname but that may replace the name of someone else.").foregroundColor(.secondary).font(.footnote)
    
    var contentList: some View {
        ForEach(namesDatabase.names.indices, id: \.self) { i in
            
            HStack {
                
                #if os(macOS)
                Image(nsImage: NSImage(named: NSImage.stopProgressTemplateName)!).foregroundColor(.red).padding(.trailing, 10).onTapGesture {
                    
                    namesDatabase.names.remove(at: i)
                }
                #else
                Image(systemName: "xmark").foregroundColor(.red).padding(.trailing, 10).onTapGesture {
                    
                    namesDatabase.names.remove(at: i)
                }
                #endif
                
                if namesDatabase.names.indices.contains(i) {
                    SecureField("Deadname", text: $namesDatabase.names[i].deadName).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Chosen name", text: $namesDatabase.names[i].currentName).textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    EmptyView()
                }
            }.padding()
            
            Divider()
        }
    }
    
    var content: some View {
        VStack {
            ScrollView {
                                
                VStack {
                    #if os(iOS)
                    Section(footer: footer) {
                        contentList
                    }
                    #else
                    contentList

                    footer
                    #endif
                }.padding()

            }.onReceive(NotificationCenter.default.publisher(for: .init(rawValue: "Add"), object: nil)) { notif in
                
                if let id = notif.object as? UUID, !cachedIds.contains(id) {
                    namesDatabase.names.append(Name(deadName: "", currentName: ""))
                    cachedIds.append(id)
                }
            }
            
            #if os(macOS)
            HStack {
                Spacer()
                DoneButton().frame(width: 60).padding()
            }
            #endif
        }
        #if os(iOS)
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: dismiss, label: {
                    Text("Done").bold()
                })
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                
                Button(action: {
                    namesDatabase.names.append(Name(deadName: "", currentName: ""))
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
        #endif
    }
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            content.navigationTitle("Configuration")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        #else
        content
        #endif
    }
}

struct Configuration_Previews: PreviewProvider {
    static var previews: some View {
        Configuration(dismiss: {})
    }
}
