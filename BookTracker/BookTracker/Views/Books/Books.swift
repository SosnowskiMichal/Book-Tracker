//
//  Books.swift
//  BookManagementApp
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct Books: View {
    
    @EnvironmentObject private var bookService: BookService
    @EnvironmentObject private var collectionService: CollectionService
    
    @State private var searchInput: String = ""
    @State private var showFavourites: Bool = false
    
    var filteredBooks: [Book] {
        bookService.books.filter { book in
            (!showFavourites || book.isFavourite) &&
            (searchInput.isEmpty || book.title!.lowercased().contains(searchInput.lowercased()) ||
             book.author!.lowercased().contains(searchInput.lowercased()))
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("My books")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    SearchBar(text: $searchInput, placeholder: "Search books, authors...")
                    
                    Toggle(isOn: $showFavourites) {
                        HStack {
                            Spacer()
                            Text("Favourites only")
                                .font(.title3)
                        }
                    }
                }
                .padding(.bottom, 5)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(filteredBooks, id: \.objectID) { book in
                            BookPreview(book)
                                .environmentObject(bookService)
                                .environmentObject(collectionService)
                        }
                        .transition(.slide)
                        .animation(.easeInOut, value: filteredBooks)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(10)
            
            if bookService.books.isEmpty {
                VStack {
                    Text("You have no books")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .navigationTitle("My books")
        .navigationBarHidden(true)
    }
    
}
