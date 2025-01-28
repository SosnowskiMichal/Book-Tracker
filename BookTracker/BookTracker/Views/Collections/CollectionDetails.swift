//
//  CollectionDetails.swift
//  BookManagementApp
//
//  Created by stud on 19/11/2024.
//

import SwiftUI

struct CollectionDetails: View {
    
    @ObservedObject var collection: BookCollection
    @EnvironmentObject var collectionService: CollectionService
    @EnvironmentObject var bookService: BookService
    
    init(_ collection: BookCollection) {
        self.collection = collection
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            let collectionItems = collection.collectionItemsArray
            
            if collectionItems.isEmpty {
                VStack {
                    Text("Collection is empty")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(collection.name ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let formattedDateCreated = FormatterService.shared.formatDate(collection.dateCreated) {
                        Text("created \(formattedDateCreated)")
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(Color(UIColor.systemGray))
                    }
                    
                    if let description = collection.collectionDescription, !description.isEmpty {
                        Text(description)
                            .font(.body)
                            .foregroundStyle(Color(UIColor.systemGray))
                            .multilineTextAlignment(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.bottom, 5)
                
                let columns = [
                    GridItem(.flexible(), alignment: .top),
                    GridItem(.flexible(), alignment: .top),
                ]
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(collectionItems, id: \.objectID) { collectionItem in
                            CollectionBookPreview(collectionItem)
                                .environmentObject(collectionService)
                                .environmentObject(bookService)
                        }
                        .transition(.slide)
                        .animation(.easeInOut, value: collectionItems)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(10)
        }
        .navigationTitle(collection.name ?? "Collection details")
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
