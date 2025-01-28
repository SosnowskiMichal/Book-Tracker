//
//  Goal+CoreDataClass.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//
//

import Foundation
import CoreData

@objc(Goal)
public class Goal: NSManagedObject {

    func calculateCompletionPercent() {
        guard booksToRead > 0 else {
            completionPercent = 0.0
            return
        }
        completionPercent = Double(booksRead) / Double(booksToRead)
    }
    
    func getCompletionPercentInteger() -> Int {
        return Int(completionPercent * 100)
    }
    
    private func checkIfOnTrack() -> (Bool, Int) {
        let currentDate = Date()
        let totalTime = finishDate!.timeIntervalSince(dateAdded!)
        let timePassed = currentDate.timeIntervalSince(dateAdded!)
        
        let percentagePassed = timePassed / totalTime;
        let currentCompletion = Double(completionPercent) / 100.0
        
        if percentagePassed <= currentCompletion {
            return (true, 0)
        }
        
        let bookTarget = Int(percentagePassed * Double(booksToRead))
        let booksBehind = bookTarget - Int(booksRead)
        return booksBehind <= 0 ? (true, 0) : (false, booksBehind)
    }
    
    func getOnOffTrackMessage() -> String {
        let (isOnTrack, booksOffTrack) = checkIfOnTrack()
        
        if isOnTrack {
            return "You're on track!"
        }
        
        return "\(booksOffTrack) book\(booksOffTrack == 1 ? "" : "s") behind schedule"
    }
    
    private func calculateTimeLeft() -> (Int, Int, Int) {
        let currentDate = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .day, .hour], from: currentDate, to: finishDate!)
        
        let months = components.month ?? 0
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        
        return (months, days, hours)
    }
    
    func getTimeLeftString() -> String {
        let (months, days, hours) = calculateTimeLeft()
        var timeString = ""
        
        if months > 0 {
            timeString += "\(months) month\(months > 1 ? "s" : "") "
        }
        if days > 0 {
            timeString += "\(days) day\(days > 1 ? "s" : "") "
        }
        if hours > 0 {
            timeString += "\(hours) hour\(hours > 1 ? "s" : "")"
        }
        
        return timeString
    }
    
    func isGoalActive() -> Bool {
        isActive = finishDate! > Date()
        return isActive
    }
    
    func isGoalCompleted() -> Bool {
        isCompleted = booksRead >= booksToRead
        return isCompleted;
    }
    
}
