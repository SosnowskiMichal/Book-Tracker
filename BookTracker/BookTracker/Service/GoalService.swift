//
//  GoalService.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import Foundation

class GoalService: ObservableObject {
    
    @Published var activeGoals: [Goal] = []
    @Published var finishedGoals: [Goal] = []
    private let repository: GoalRepository
    
    init(repository: GoalRepository = GoalRepository()) {
        self.repository = repository
        updateActiveGoals()
//        addDemoFinishedGoals()
        fetchGoals()
    }
    
    func fetchGoals() {
        activeGoals = repository.fetchActiveGoals()
        finishedGoals = repository.fetchFinishedGoals()
    }
    
    func updateActiveGoals() {
        activeGoals = repository.fetchActiveGoals()
        for goal in activeGoals {
            updateGoal(goal)
        }
    }
    
    func updateGoal(_ goal: Goal) {
        repository.updateGoal(goal)
    }

    func validateGoal(name: String, booksToRead: String, finishDate: Date) -> Bool {
        guard let books = Int64(booksToRead), !name.isEmpty, name.count <= 50, books > 0, finishDate >= Date() else {
            return false
        }
        let adjustedFinishDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: finishDate) ?? finishDate
        addGoal(name: name, booksToRead: books, finishDate: adjustedFinishDate)
        return true
    }
    
    func addGoal(name: String, booksToRead: Int64, finishDate: Date) {
        repository.addGoal(name: name, booksToRead: booksToRead, finishDate: finishDate)
        updateActiveGoals()
        fetchGoals()
    }
    
    func deleteGoal(_ goal: Goal) {
        repository.deleteGoal(goal)
        updateActiveGoals()
        fetchGoals()
    }
    
    func increaseGoalsProgress(_ book: Book) {
        updateActiveGoals()
        fetchGoals()
        for goal in activeGoals {
            repository.increaseGoalProgress(goal, book)
            repository.updateGoal(goal)
        }
        fetchGoals()
    }
    
    func decreaseGoalsProgress(_ book: Book) {
        updateActiveGoals()
        let goalsWithFutureFinishDate = repository.fetchGoalsWithFutureFinishDate()
        for goal in goalsWithFutureFinishDate {
            repository.decreaseGoalProgress(goal, book)
            repository.updateGoal(goal)
        }
        fetchGoals()
    }
    
    // !!! FOR DEMO ONLY
    func addDemoFinishedGoals() {
        repository.addDemoFinishedGoal(completed: true)
        repository.addDemoFinishedGoal(completed: false)
    }
    
}
