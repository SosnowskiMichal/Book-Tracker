//
//  GoalRepository.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import Foundation
import CoreData

class GoalRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchActiveGoals() -> [Goal] {
        let request = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: true))
        request.sortDescriptors = [NSSortDescriptor(key: "finishDate", ascending: true)]
        
        do { return try context.fetch(request) }
        catch {
            print("Failed to fetch active goals: \(error)")
            return []
        }
    }
    
    func fetchFinishedGoals() -> [Goal] {
        let request = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "isActive == %@", NSNumber(value: false))
        request.sortDescriptors = [NSSortDescriptor(key: "finishDate", ascending: false)]
        
        do { return try context.fetch(request) }
        catch {
            print("Failed to fetch finished goals: \(error)")
            return []
        }
    }
    
    func fetchGoalsWithFutureFinishDate() -> [Goal] {
        let request = Goal.fetchRequest()
        let currentDate = Date()
        request.predicate = NSPredicate(format: "finishDate >= %@", currentDate as NSDate)
        
        do { return try context.fetch(request) }
        catch {
            print("Failed to fetch goals with future finish date: \(error)")
            return []
        }
    }
    
    func fetchNumberOfActiveGoals() -> Int? {
        let request = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "isActive = %@", NSNumber(value: true))
        
        do { return try context.count(for: request) }
        catch {
            print("Error fetching active goals: \(error)")
            return nil
        }
    }
    
    func fetchNumberOfFinishedGoals(isCompleted: Bool) -> Int? {
        let request = Goal.fetchRequest()
        
        let isActivePredicate = NSPredicate(format: "isActive = %@", NSNumber(value: false))
        let isCompletedPredicate = NSPredicate(format: "isCompleted = %@", NSNumber(value: isCompleted))
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isActivePredicate, isCompletedPredicate])
        
        do { return try context.count(for: request) }
        catch {
            print("Error fetching \(isCompleted ? "completed" : "not completed") goals: \(error)")
            return nil
        }
    }
    
    func updateGoal(_ goal: Goal) {
        goal.calculateCompletionPercent()
        
        if goal.getCompletionPercentInteger() == 100 {
            goal.isActive = false
            goal.isCompleted = true
        } else {
            _ = goal.isGoalActive()
            _ = goal.isGoalCompleted()
        }
        
        saveContext()
    }
    
    func addGoal(name: String, booksToRead: Int64, finishDate: Date) {
        let newGoal = Goal(context: context)
        newGoal.name = name
        newGoal.booksRead = 0
        newGoal.booksToRead = booksToRead
        newGoal.dateAdded = Date()
        newGoal.finishDate = finishDate
        _ = newGoal.isGoalActive()
        _ = newGoal.isGoalCompleted()
        saveContext()
    }
    
    func deleteGoal(_ goal: Goal) {
        checkForAndDeleteBookCovers(goal)
        context.delete(goal)
        saveContext()
    }
    
    private func checkForAndDeleteBookCovers(_ goal: Goal) {
        for goalItem in goal.goalItemsArray {
            if let bookCover = goalItem.bookCover, bookCover.book == nil {
                context.delete(bookCover)
            }
        }
    }
    
    func increaseGoalProgress(_ goal: Goal, _ book: Book) {
        addGoalItem(goal, book)
        goal.booksRead += 1
        saveContext()
    }
    
    private func addGoalItem(_ goal: Goal, _ book: Book) {
        if let bookCover = book.bookCover {
            let item = GoalItem(context: context)
            item.dateAdded = Date()
            goal.addToGoalItems(item)
            bookCover.addToGoalItems(item)
            saveContext()
        }
    }
    
    func decreaseGoalProgress(_ goal: Goal, _ book: Book) {
        let connected = checkForAndDeleteGoalItem(goal, book)
        if connected {
            goal.booksRead -= 1
            saveContext()
        }
    }
    
    private func checkForAndDeleteGoalItem(_ goal: Goal, _ book: Book) -> Bool {
        for goalItem in goal.goalItemsArray {
            if let tmpBook = goalItem.bookCover?.book, tmpBook.objectID == book.objectID {
                context.delete(goalItem)
                return true
            }
        }
        return false
    }
    
    // !!! FOR DEMO ONLY
    func addDemoFinishedGoal(completed: Bool) {
        let newGoal = Goal(context: context)
        newGoal.name = "Demo \(completed ? "" : "not ")completed"
        newGoal.booksRead = 5
        newGoal.booksToRead = completed ? 5 : 10
        newGoal.completionPercent = completed ? 1.0 : 0.5
        newGoal.dateAdded = Date().addingTimeInterval(-14 * 24 * 60 * 60)
        newGoal.finishDate = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        newGoal.isActive = false
        newGoal.isCompleted = completed
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
