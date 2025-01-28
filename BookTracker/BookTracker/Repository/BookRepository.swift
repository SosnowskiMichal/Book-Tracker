//
//  BookRepository.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import Foundation
import CoreData

class BookRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchBooks() -> [Book] {
        let request = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do { return try context.fetch(request) }
        catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }
    
    func fetchBookByKey(_ key: String) -> Book? {
        let request = Book.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key)
        
        do { return try context.fetch(request).first }
        catch {
            print("Failed to fetch book with key \(key): \(error)")
            return nil
        }
    }
    
    func fetchLastAddedBook() -> Book? {
        let request = Book.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        request.fetchLimit = 1
        
        do { return try context.fetch(request).first }
        catch {
            print("Failed to fetch last added book: \(error)")
            return nil
        }
    }
    
    func fetchLastReadBook() -> Book? {
        let request = Book.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@", "Read")
        request.sortDescriptors = [NSSortDescriptor(key: "statusChangeDate", ascending: false)]
        request.fetchLimit = 1
        
        do { return try context.fetch(request).first }
        catch {
            print("Failed to fetch last read book: \(error)")
            return nil
        }
    }
    
    func fetchNumberOfBooks() -> Int? {
        let request = Book.fetchRequest()
        
        do { return try context.count(for: request) }
        catch {
            print("Error fetching number of books: \(error)")
            return nil
        }
    }
    
    func fetchNumberOfBooksReadInLast30Days() -> Int? {
        let request = Book.fetchRequest()
        
        let now = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        let statusPredicate = NSPredicate(format: "status == %@", "Read")
        let datePredicate = NSPredicate(format: "statusChangeDate >= %@", thirtyDaysAgo as NSDate)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, datePredicate])
        
        do { return try context.count(for: request) }
        catch {
            print("Error fetching books read in the last 30 days: \(error)")
            return nil
        }
    }
    
    func fetchNumberOfBooksWithStatus(_ status: String) -> Int? {
        let request = Book.fetchRequest()
        request.predicate = NSPredicate(format: "status = %@", status)
        
        do { return try context.count(for: request) }
        catch {
            print("Error fetching '\(status)' books: \(error)")
            return nil
        }
    }
    
    func findBookCoverByKey(_ key: String) -> BookCover? {
        let request = BookCover.fetchRequest()
        request.predicate = NSPredicate(format: "bookKey == %@", key)
        
        do { return try context.fetch(request).first }
        catch {
            print("Failed to fetch book cover with book key \(key): \(error)")
            return nil
        }
    }
    
    func addBook(bookDto: BookDto, coverImage: Data?) {
        let book = Book(context: context)
        book.key = bookDto.key
        book.title = bookDto.title
        book.author = bookDto.author
        book.bookDescription = bookDto.bookDescription
        book.publishYear = bookDto.publishYear ?? 0
        book.dateAdded = bookDto.dateAdded
        book.isFavourite = bookDto.isFavourite ?? false
        book.status = bookDto.status
        book.statusChangeDate = bookDto.statusChangeDate
        
        addBookCover(book: book, coverImage: coverImage)
        saveContext()
    }
    
    private func addBookCover(book: Book, coverImage: Data?) {
        var bookCover: BookCover?
        if let key = book.key {
            bookCover = findBookCoverByKey(key)
        }
        if bookCover == nil {
            bookCover = BookCover(context: context)
        }
        
        bookCover!.coverImage = coverImage
        book.bookCover = bookCover
        bookCover!.book = book
        saveContext()
    }
    
    func deleteBook(_ book: Book) {
        checkForAndDeleteBookCover(book)
        context.delete(book)
        saveContext()
    }
    
    private func checkForAndDeleteBookCover(_ book: Book) {
        if let bookCover = book.bookCover, bookCover.goalItemsArray.isEmpty {
            context.delete(bookCover)
            saveContext()
        }
    }
    
    func toggleFavourite(_ book: Book) {
        book.isFavourite.toggle()
        saveContext()
    }
    
    func addNote(_ book: Book, _ noteContent: String) {
        let newNote = BookNote(context: context)
        newNote.content = noteContent
        newNote.dateAdded = Date()
        book.addToBookNotes(newNote)
        saveContext()
    }
    
    func deleteNote(_ book: Book, _ note: BookNote) {
        context.delete(note)
        saveContext()
    }
    
    func addBookToCollection(_ book: Book, _ collection: BookCollection) {
        let item = BookCollectionItem(context: context)
        item.dateAdded = Date()
        book.addToCollectionItems(item)
        collection.addToCollectionItems(item)
        saveContext()
    }
    
    func changeBookStatus(_ book: Book, _ status: String) {
        book.status = status
        book.statusChangeDate = Date()
        saveContext()
    }
    
    private func saveContext() {
        if context.hasChanges {
            do { try context.save() }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
