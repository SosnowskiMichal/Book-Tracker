//
//  Search.swift
//  BookManagementApp
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct SearchResultAlert {
    var showingAlertMessage: Bool = false
    var addBookResult: Bool? = nil
    var bookTitle: String = ""
    var bookAuthor: String = ""
}

struct Search: View {
    
    @EnvironmentObject private var searchService: SearchService
    @EnvironmentObject private var bookService: BookService
    
    @State private var isLoading = false
    @State private var searchInput: String = ""
    @State private var apiBooks: [ApiBook] = []
    
    @State private var showingAlertError: Bool = false
    @State private var searchResultAlert = SearchResultAlert()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Search")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    SearchBar(text: $searchInput, placeholder: "Search books, authors...")
                        .onChange(of: searchInput) { newValue in
                            if newValue.isEmpty { apiBooks = [] }
                        }
                        .onSubmit {
                            Task { await searchForBooks() }
                        }
                }
                .padding(.bottom, 5)
                .alert(isPresented: $showingAlertError) {
                    Alert(
                        title: Text("Error"),
                        message: Text("Unable to download data"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(apiBooks) { apiBook in
                            SearchResult(apiBook: apiBook, searchResultAlert: $searchResultAlert)
                                .environmentObject(bookService)
                        }
                        .transition(.slide)
                        .animation(.easeInOut, value: apiBooks.count)
                        
                        if !apiBooks.isEmpty {
                            if isLoading {
                                ProgressView("Loading...")
                                    .padding(.top, 10)
                            } else {
                                Button {
                                    Task { await searchForBooks() }
                                } label: {
                                    Image(systemName: "plus.app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                }
                                .padding(.vertical, 30)
                                .foregroundStyle(Color(UIColor.systemGray))
                            }
                        }
                    }
                }
                .alert(isPresented: $searchResultAlert.showingAlertMessage) {
                    Alert(
                        title: Text(searchResultAlert.addBookResult ?? false ? "Book added to library" : "Book already added"),
                        message: Text("\(searchResultAlert.bookTitle), \(searchResultAlert.bookAuthor)"),
                        dismissButton: .default(Text("OK")) {
                            searchResultAlert.addBookResult = nil
                            searchResultAlert.bookTitle = ""
                            searchResultAlert.bookAuthor = ""
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(10)
            
            if apiBooks.isEmpty || isLoading {
                VStack {
                    if isLoading {
                        ProgressView("Loading...")
                    } else {
                        Text("Search for books\nin Open Library database")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Search")
        .navigationBarHidden(true)
    }
    
    private func searchForBooks() async {
        if searchInput.isEmpty { return }
        
        isLoading = true
        defer { isLoading = false }

        let requestResult = await searchService.getBooks(searchInput)

        if requestResult == nil {
            showingAlertError = true
        }
        
        if let requestResult = requestResult {
            if searchService.getPageNumber() == 1 {
                apiBooks = requestResult
            } else {
                apiBooks += requestResult
            }
        }
    }
    
}
