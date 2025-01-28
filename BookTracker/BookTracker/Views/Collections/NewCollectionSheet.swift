//
//  NewCollectionSheet.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

struct NewCollectionSheet: View {
    
    @Binding var collectionName: String
    @Binding var collectionDescription: String
    @Binding var showingSheet: Bool
    var onSave: (String, String) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Add new book collection")) {
                TextField("Collection name", text: $collectionName)
                TextField("Description (optional)", text: $collectionDescription)
            }
            
            Section {
                HStack {
                    Button("Save collection") {
                        onSave(collectionName, collectionDescription)
                        showingSheet = false
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(
                        collectionName.isEmpty
                        || collectionName.count > 100
                        || collectionDescription.count > 500
                    )
                    
                    Spacer()
                    
                    Button("Cancel") {
                        showingSheet = false
                    }
                    .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
    
}

//#Preview {
//    NewCollectionSheet(
//        collectionName: .constant(""),
//        collectionDescription: .constant(""),
//        showingSheet: .constant(true),
//        onSave: { _,_ in }
//    )
//}
