//
//  StatisticsService.swift
//  BookManagementApp
//
//  Created by stud on 14/01/2025.
//

import Foundation

class StatisticsService {
    
    private let bookRepository: BookRepository
    private let collectionRepository: CollectionRepository
    private let goalRepository: GoalRepository
    
    init() {
        bookRepository = BookRepository()
        collectionRepository = CollectionRepository()
        goalRepository = GoalRepository()
    }
    
    func getNumberOfBooks() -> Int {
        if let totalBooks = bookRepository.fetchNumberOfBooks() {
            return totalBooks
        }
        return 0
    }
    
    func getBookStatusesInfo() -> (Int, Int, Int) {
        if let wantToRead = bookRepository.fetchNumberOfBooksWithStatus("Want to read"),
           let reading = bookRepository.fetchNumberOfBooksWithStatus("Reading"),
           let read = bookRepository.fetchNumberOfBooksWithStatus("Read") {
            return (wantToRead, reading, read)
        }
        return (0, 0, 0)
    }
    
    func getBooksReadInLast30Days() -> Int {
        if let booksRead = bookRepository.fetchNumberOfBooksReadInLast30Days() {
            return booksRead
        }
        return 0
    }
    
    func getLastReadBook() -> (String?, String?) {
        if let book = bookRepository.fetchLastReadBook() {
            return (book.title, book.author)
        }
        return (nil, nil)
    }
    
    func getLastAddedBook() -> (String?, String?) {
        if let book = bookRepository.fetchLastAddedBook() {
            return (book.title, book.author)
        }
        return (nil, nil)
    }
    
    func getGoalsInfo() -> (Int, Int, Int) {
        if let activeGoals = goalRepository.fetchNumberOfActiveGoals(),
           let completedGoals = goalRepository.fetchNumberOfFinishedGoals(isCompleted: true),
           let notCompletedGoals = goalRepository.fetchNumberOfFinishedGoals(isCompleted: false) {
            return (activeGoals, completedGoals, notCompletedGoals)
        }
        return (0, 0, 0)
    }
    
    func getNumberOfCollections() -> Int {
        if let totalCollections = collectionRepository.fetchNumberOfCollections() {
            return totalCollections
        }
        return 0
    }
    
}
