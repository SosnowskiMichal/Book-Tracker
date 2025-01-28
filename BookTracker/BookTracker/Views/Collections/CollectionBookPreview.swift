//
//  CollectionBookPreview.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

struct CollectionBookPreview: View {
    
    @ObservedObject var collectionItem: BookCollectionItem
    @EnvironmentObject var collectionService: CollectionService
    @EnvironmentObject var bookService: BookService
    
    @State private var showingAlert: Bool = false

    init(_ collectionItem: BookCollectionItem) {
        self.collectionItem = collectionItem
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            NavigationLink {
                if let book = collectionItem.book {
                    BookDetails(book)
                        .environmentObject(bookService)
                }
            } label: {
                VStack {
                    VStack {
                        if let imageData = collectionItem.book?.bookCover?.coverImage, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width / 4, maxHeight: 180)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                        } else {
                            Image("no-image")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: UIScreen.main.bounds.width / 4, maxHeight: 180)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(collectionItem.book?.title ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .truncationMode(.tail)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.primary)
                        
                        Text(collectionItem.book?.author ?? "")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            
            if let formattedDateAdded = FormatterService.shared.formatDate(collectionItem.dateAdded) {
                Text("added \(formattedDateAdded)")
                    .font(.subheadline)
                    .italic()
                    .foregroundStyle(Color(UIColor.systemGray))
            }
            
            HStack {
                DeleteButton(buttonLabel: "Remove", action: {
                    showingAlert = true
                })
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .trailing)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(5)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Remove this book from collection?"),
                message: Text("\(collectionItem.book?.title ?? ""), \(collectionItem.book?.author ?? "")"),
                primaryButton: .destructive(Text("Remove")) {
                    collectionService.deleteCollectionItem(collectionItem)
                },
                secondaryButton: .cancel()
            )
        }
    }

}
