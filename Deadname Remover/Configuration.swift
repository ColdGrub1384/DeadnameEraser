//
//  Configuration.swift
//  Deadname Remover
//
//  Created by Emma Labbé on 08-06-21.
//

import SwiftUI

struct Configuration: View {
    
    @ObservedObject var namesDatabase = NamesDatabase.shared
    
    var dismiss: (() -> Void)
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        ForEach($namesDatabase.names) { element in
                            
                            HStack {
                                SecureField("Deadname", text: element.deadName)
                                
                                TextField("Choosen name", text: element.currentName)
                            }.padding()
                        }.onDelete { indexSet in
                            guard let i = indexSet.first else {
                                return
                            }
                            
                            namesDatabase.names.remove(at: i)
                        }
                    } footer: {
                        Text("Type every variant of the name that you previously used so the web extension can replace it. Case doesn't matter. You can add your firstname and lastname together or you can just write your firstname but that may replace the name of someone else.")
                    }

                }
                
                Spacer()
            }
            .navigationBarTitle("Configuration")
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: dismiss, label: {
                        Text("Done").bold()
                    })
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    EditButton()
                    
                    Button(action: {
                        namesDatabase.names.append(Name(deadName: "", currentName: ""))
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Configuration_Previews: PreviewProvider {
    static var previews: some View {
        Configuration(dismiss: {})
    }
}
