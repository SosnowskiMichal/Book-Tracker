//
//  AddToCollectionSheet.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//

import SwiftUI

struct AddToCollectionSheet: View {
    
    @EnvironmentObject var collectionService: CollectionService
    
    @Binding var selectedCollection: BookCollection?
    @Binding var showingSheet: Bool
    var onSave: (BookCollection) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Select collection")) {
                List(collectionService.collections, id: \.objectID) { collection in
                    HStack(alignment: .center, spacing: 10) {
                        if selectedCollection?.objectID == collection.objectID {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundStyle(Color(UIColor.systemBlue))
                        } else {
                            Image(systemName: "square")
                        }
                        
                        Text(collection.name ?? "Untitled collection")
                            .font(.body)
                            .foregroundStyle(
                                selectedCollection?.objectID == collection.objectID
                                ? Color(UIColor.systemBlue)
                                : Color.primary
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCollection = collection
                    }
                }
            }
            
            Section {
                HStack {
                    Button("Add to collection") {
                        if let collection = selectedCollection {
                            onSave(collection)
                            showingSheet = false
                        }
                    }
                    .disabled(selectedCollection == nil)
                    
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
