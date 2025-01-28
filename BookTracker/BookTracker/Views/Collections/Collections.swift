//
//  Collections.swift
//  BookManagementApp
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct Collections: View {
    
    @EnvironmentObject private var collectionService: CollectionService
    @EnvironmentObject private var bookService: BookService
    
    @State private var showingSheet = false
    @State private var collectionName: String = ""
    @State private var collectionDescription: String = ""
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                HStack(alignment: .center) {
                    Text("Collections")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if !collectionService.collections.isEmpty {
                        AddButton(buttonLabel: "Add collection", action: {
                            collectionName = ""
                            collectionDescription = ""
                            showingSheet.toggle()
                        })
                    }
                }
                .padding(.bottom, 5)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(collectionService.collections, id: \.objectID) { collection in
                            CollectionPreview(collection)
                                .environmentObject(collectionService)
                                .environmentObject(bookService)
                        }
                        .transition(.slide)
                        .animation(.easeInOut, value: collectionService.collections)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(10)
            
            if collectionService.collections.isEmpty {
                VStack(spacing: 20) {
                    Text("You have no collections")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    AddButton(buttonLabel: "Add collection", large: true, action: {
                        collectionName = ""
                        collectionDescription = ""
                        showingSheet.toggle()
                    })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Collections")
        .navigationBarHidden(true)
        .sheet(isPresented: $showingSheet) {
            NewCollectionSheet(
                collectionName: $collectionName,
                collectionDescription: $collectionDescription,
                showingSheet: $showingSheet,
                onSave: validateCollection
            )
        }
    }
    
    private func validateCollection(name: String, description: String) {
        let validationResult = collectionService.validateCollection(
            name: name,
            description: description
        )
        
        if validationResult {
            showingSheet.toggle()
        }
    }
    
}
