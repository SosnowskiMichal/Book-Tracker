//
//  SearchResult.swift
//  BookManagementApp
//
//  Created by stud on 21/01/2025.
//

import SwiftUI

struct SearchResult: View {
    
    @EnvironmentObject private var bookService: BookService
    var apiBook: ApiBook
    @Binding var searchResultAlert: SearchResultAlert
    
    @State private var imageData: Data?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if let cover_i = apiBook.cover_i,
                let url = URL(string: "https://covers.openlibrary.org/b/id/\(cover_i)-M.jpg") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .cornerRadius(5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100, alignment: .center)
                }
            } else {
                Image("no-image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .cornerRadius(5)
            }

            
            VStack(alignment: .leading, spacing: 5) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(apiBook.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text(apiBook.author_name.joined(separator: ", "))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                }
                
                Text("published " + String(apiBook.first_publish_year))
                    .font(.subheadline)
                    .italic()
                    .foregroundStyle(Color(UIColor.systemGray))
                
                Spacer()
                
                VStack {
                    AddButton(buttonLabel: "Add book", large: false) {
                        Task {
                            if let cover_i = apiBook.cover_i,
                                let url = URL(string: "https://covers.openlibrary.org/b/id/\(cover_i)-M.jpg") {
                                imageData = await loadImageData(from: url)
                            }
                            searchResultAlert.addBookResult = await bookService.addBook(apiBook: apiBook, coverImage: imageData)
                            searchResultAlert.bookTitle = apiBook.title
                            searchResultAlert.bookAuthor = apiBook.author_name.joined(separator: ", ")
                            searchResultAlert.showingAlertMessage = true
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(5)
    }
    
    private func loadImageData(from url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                return uiImage.jpegData(compressionQuality: 1.0)
            }
        } catch {
            print("Failed to load image data: \(error)")
            return nil
        }
        return nil
    }
    
}
