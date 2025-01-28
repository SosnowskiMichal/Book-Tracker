//
//  BookDetails.swift
//  BookManagementApp
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct BookDetails: View {
    
    @ObservedObject var book: Book
    @EnvironmentObject var bookService: BookService
    
    @State private var showingNoteSheet: Bool = false
    @State private var showingStatusSheet: Bool = false
    
    @State private var noteContent: String = ""
    @State private var selectedStatus: String
    
    init(_ book: Book) {
        self.book = book
        self.selectedStatus = book.status ?? ""
    }
        
    var body: some View {
        ZStack(alignment: .top) {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if let imageData = book.bookCover?.coverImage, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .cornerRadius(5)
                    } else {
                        Image("no-image")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 350)
                            .cornerRadius(5)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(book.title ?? "")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text(book.author ?? "")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            if let bookStatus = book.status, !bookStatus.isEmpty {
                                BookStatus(statusLabel: bookStatus, large: true, onTap: {
                                    showingStatusSheet = true
                                })
                            }
                            
                            Spacer()
                            
                            FavouriteButton(isSet: Binding (
                                get: { book.isFavourite },
                                set: { newValue in bookService.toggleFavourite(book) }
                            ), iconSize: 35)
                        }
                        
                        if let bookDescription = book.bookDescription {
                            VStack {
                                Text(bookDescription)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(10)
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(5)
                        } else {
                            VStack {}
                            .padding(.bottom, 10)
                        }
                        
                        HStack(alignment: .center) {
                            Text("Notes")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            AddButton(buttonLabel: "Add note", action: {
                                noteContent = ""
                                showingNoteSheet = true
                            })
                        }
                        
                        let bookNotesArray = book.bookNotesArray
                        
                        LazyVStack(alignment: .leading, spacing: 10) {
                            if bookNotesArray.isEmpty {
                                Text("You have no notes")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .padding(.top, 10)
                                    .padding(.bottom, 50)
                            }
                            
                            ForEach (bookNotesArray, id: \.objectID) { bookNote in
                                Note(bookNote)
                                    .environmentObject(bookService)
                            }
                            .transition(.slide)
                            .animation(.easeInOut, value: bookNotesArray.count)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(10)
            }
        }
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingStatusSheet) {
            ChangeBookStatusSheet(
                selectedStatus: $selectedStatus,
                showingSheet: $showingStatusSheet,
                onSave: changeBookStatus
            )
        }
        .sheet(isPresented: $showingNoteSheet) {
            NewNoteSheet(
                noteContent: $noteContent,
                showingSheet: $showingNoteSheet,
                onSave: addNote
            )
        }
    }
    
    private func changeBookStatus(selectedStatus: String) {
        bookService.changeBookStatus(book, selectedStatus)
    }
    
    private func addNote(noteContent: String) {
        bookService.addNote(book, noteContent)
    }
    
}
