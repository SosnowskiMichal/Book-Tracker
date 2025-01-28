//
//  BookPreview.swift
//  BookManagementApp
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct BookPreview: View {
    
    @ObservedObject var book: Book
    @EnvironmentObject var bookService: BookService
    @EnvironmentObject var collectionService: CollectionService
    
    @State private var showingAlertMessage: Bool = false
    @State private var showingAlertDelete: Bool = false
    @State private var showingCollectionSheet: Bool = false
    @State private var showingStatusSheet: Bool = false
    
    @State private var selectedCollection: BookCollection? = nil
    @State private var addToCollectionResult: Bool? = nil
    @State private var selectedStatus: String
    
    init(_ book: Book) {
        self.book = book
        self.selectedStatus = book.status ?? ""
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            NavigationLink {
                BookDetails(book)
                    .environmentObject(bookService)
            } label: {
                if let imageData = book.bookCover?.coverImage, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .cornerRadius(5)
                } else {
                    Image("no-image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .cornerRadius(5)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 10) {
                        NavigationLink {
                            BookDetails(book)
                                .environmentObject(bookService)
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(book.title ?? "")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                
                                Text(book.author ?? "")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .foregroundStyle(Color.primary)
                        .navigationBarHidden(true)
                        
                        if let formattedDateAdded = FormatterService.shared.formatDate(book.dateAdded) {
                            Text("added \(formattedDateAdded)")
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(Color(UIColor.systemGray))
                        }
                    }
                    
                    Spacer()
                    
                    FavouriteButton(isSet: Binding(
                        get: { book.isFavourite },
                        set: { newValue in bookService.toggleFavourite(book) }
                    ))
                }
                .alert(isPresented: $showingAlertMessage) {
                    Alert(
                        title: Text(addToCollectionResult ?? false
                                    ? "Book added to collection"
                                    : "Book already in collection"),
                        message: Text("\(book.title ?? ""), \(book.author ?? "")"),
                        dismissButton: .default(Text("OK")) {
                            addToCollectionResult = nil
                        }
                    )
                }
                
                if let bookStatus = book.status, !bookStatus.isEmpty {
                    BookStatus(statusLabel: bookStatus, onTap: {
                        selectedStatus = bookStatus
                        showingStatusSheet = true
                    })
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    AddButton(buttonLabel: "Collection", action: {
                        selectedCollection = nil
                        showingCollectionSheet = true
                    })
                    
                    DeleteButton(buttonLabel: "Remove", action: {
                        showingAlertDelete = true
                    })
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .alert(isPresented: $showingAlertDelete) {
                    Alert(
                        title: Text("Remove this book?"),
                        message: Text("\(book.title ?? ""), \(book.author ?? "")"),
                        primaryButton: .destructive(Text("Remove")) {
                            bookService.deleteBook(book)
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(5)
        .sheet(isPresented: $showingStatusSheet) {
            ChangeBookStatusSheet(
                selectedStatus: $selectedStatus,
                showingSheet: $showingStatusSheet,
                onSave: changeBookStatus
            )
        }
        .sheet(isPresented: $showingCollectionSheet) {
            AddToCollectionSheet(
                selectedCollection: $selectedCollection,
                showingSheet: $showingCollectionSheet,
                onSave: addToCollection
            )
                .environmentObject(collectionService)
                .onDisappear {
                    if addToCollectionResult != nil {
                        showingAlertMessage = true
                    }
                }
        }
    }
    
    private func changeBookStatus(selectedStatus: String) {
        bookService.changeBookStatus(book, selectedStatus)
    }
    
    private func addToCollection(selectedCollection: BookCollection) {
        addToCollectionResult = bookService.addBookToCollection(book, selectedCollection)
    }
    
}
