//
//  CollectionPreview.swift
//  BookManagementApp
//
//  Created by stud on 26/11/2024.
//

import SwiftUI

struct CollectionPreview: View {
    
    @ObservedObject var collection: BookCollection
    @EnvironmentObject var collectionService: CollectionService
    @EnvironmentObject var bookService: BookService
    
    @State private var showingAlert: Bool = false
    
    init(_ collection: BookCollection) {
        self.collection = collection
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .top) {
                NavigationLink {
                    CollectionDetails(collection)
                        .environmentObject(collectionService)
                        .environmentObject(bookService)
                } label: {
                    Text(collection.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                }
                .foregroundStyle(Color.primary)
                
                Spacer()
                
                DeleteButton(buttonLabel: "Remove", action: {
                    showingAlert = true
                })
            }
            
            if collection.collectionItemsArray.isEmpty {
                Text("Collection is empty")
                    .font(.headline)
                    .italic()
                    .foregroundStyle(Color(UIColor.systemGray))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(collection.collectionItemsArray, id: \.id) { collectionItem in
                            if let imageData = collectionItem.book?.bookCover?.coverImage, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .cornerRadius(5)
                            } else {
                                Image("no-image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(5)
        .alert(isPresented: $showingAlert) {
            return Alert(
                title: Text("Remove this collection?"),
                message: Text(collection.name ?? ""),
                primaryButton: .destructive(Text("Remove")) {
                    collectionService.deleteCollection(collection)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
}
