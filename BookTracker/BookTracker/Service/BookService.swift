//
//  BookService.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import Foundation
import SwiftUI

class BookService: ObservableObject {
    
    @Published var books: [Book] = []
    private var goalService: GoalService
    private var searchService: SearchService
    private let repository: BookRepository
    
    init(_ goalService: GoalService, _ searchService: SearchService, repository: BookRepository = BookRepository()) {
        self.goalService = goalService
        self.searchService = searchService
        self.repository = repository
        fetchBooks()
    }
    
    func fetchBooks() {
        books = repository.fetchBooks()
    }
    
    func addBook(apiBook: ApiBook, coverImage: Data?) async -> Bool {
        let bookKey = apiBook.key.replacingOccurrences(of: "/works/", with: "")
        if repository.fetchBookByKey(bookKey) != nil {
            return false
        }
        
        var bookDescription = await searchService.getBookDescription(apiBook.key)
        bookDescription = cutDescription(input: bookDescription)

        var bookDto = BookDto()
        bookDto.key = bookKey
        bookDto.title = apiBook.title
        bookDto.author = Array(apiBook.author_name.prefix(2)).joined(separator: ", ")
        bookDto.bookDescription = bookDescription
        bookDto.publishYear = Int64(apiBook.first_publish_year)
        bookDto.dateAdded = Date()
        bookDto.isFavourite = false
        bookDto.status = "Want to read"
        bookDto.statusChangeDate = Date()

        repository.addBook(bookDto: bookDto, coverImage: coverImage)
        await MainActor.run {
            fetchBooks()
        }
        return true
    }
    
    private func cutDescription(input: String?) -> String? {
        if input == nil { return input }
        
        if let input = input, let range = input.range(of: "\r\n\r\n----------") {
            var result = input[input.startIndex..<range.lowerBound]
            while result.hasSuffix("\r\n") {
                result.removeLast(2)
            }
            return String(result)
        }
        return input
    }
    
    func deleteBook(_ book: Book) {
        repository.deleteBook(book)
        fetchBooks()
    }
    
    func toggleFavourite(_ book: Book) {
        repository.toggleFavourite(book)
        fetchBooks()
    }
    
    func addNote(_ book: Book, _ noteContent: String) {
        guard !noteContent.isEmpty, noteContent.count <= 500 else { return }
        repository.addNote(book, noteContent)
    }
    
    func deleteNote(_ book: Book, _ note: BookNote) {
        repository.deleteNote(book, note)
    }
    
    func addBookToCollection(_ book: Book, _ collection: BookCollection) -> Bool {
        for collectionItem in collection.collectionItemsArray {
            if let itemBook = collectionItem.book, itemBook.objectID == book.objectID {
                return false
            }
        }
        repository.addBookToCollection(book, collection)
        return true
    }
    
    func changeBookStatus(_ book: Book, _ status: String) {
        if let bookStatus = book.status, bookStatus == status { return }
        checkAndUpdateGoalsProgress(book, status)
        repository.changeBookStatus(book, status)
    }
    
    private func checkAndUpdateGoalsProgress(_ book: Book, _ status: String) {
        let oldStatus = book.status ?? ""
        if oldStatus == status { return }
        
        if status == "Read" {
            goalService.increaseGoalsProgress(book)
        } else if oldStatus == "Read" {
            goalService.decreaseGoalsProgress(book)
        }
    }
    
}
