//
//  Goal.swift
//  BookManagementApp
//
//  Created by stud on 26/11/2024.
//

import SwiftUI

struct GoalPreview: View {
    
    @ObservedObject var goal: Goal
    @EnvironmentObject var goalService: GoalService
    
    @State private var showingAlert: Bool = false
    
    init(_ goal: Goal) {
        self.goal = goal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Text(goal.name ?? "")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    DeleteButton(buttonLabel: "Remove", action: {
                        showingAlert = true
                    })

                }
                
                if !goal.isActive {
                    if let formattedDateAdded = FormatterService.shared.formatDate(goal.dateAdded),
                       let formattedFinishDate = FormatterService.shared.formatDate(goal.finishDate) {
                        Text("\(formattedDateAdded) - \(formattedFinishDate)")
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(Color(UIColor.systemGray))
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                if !goal.isActive {
                    if goal.isCompleted {
                        Text("GOAL COMPLETED")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.systemGreen))
                    } else {
                        Text("GOAL NOT COMPLETED")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.systemRed))
                    }
                }
                
                HStack(alignment: .bottom, spacing: 5) {
                    Text("\(goal.booksRead)/\(goal.booksToRead)")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("books completed (\(goal.getCompletionPercentInteger())%)")
                        .font(.body)
                }
                
                ProgressView(value: goal.completionPercent)
                    .accentColor(goal.isActive
                                 ? Color(UIColor.systemBlue)
                                 : goal.isCompleted
                                     ? Color(UIColor.systemGreen)
                                     : Color(UIColor.systemRed))

                if goal.isActive {
                    Text(goal.getOnOffTrackMessage())
                        .foregroundStyle(Color(UIColor.systemGray))
                }
            }
            
            if !goal.goalItemsArray.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(goal.goalItemsArray, id: \.id) { goalItem in
                            if let imageData = goalItem.bookCover?.coverImage, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .cornerRadius(5)
                            } else {
                                Image("no-image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            
            if goal.isActive {
                HStack(spacing: 5) {
                    Text("Time left:")
                        .font(.body)
                        .fontWeight(.bold)
                    
                    Text(goal.getTimeLeftString())
                        .font(.subheadline)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(5)
        .overlay(!goal.isActive && goal.booksToRead != 0 ? getFinishedGoalOverlay(goal.isCompleted) : nil)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Remove this goal?"),
                message: Text(goal.name ?? ""),
                primaryButton: .destructive(Text("Remove")) {
                    goalService.deleteGoal(goal)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func getFinishedGoalOverlay(_ isCompleted: Bool) -> some View {
        let overlay = RoundedRectangle(cornerRadius: 5).inset(by: 1)
        if isCompleted {
            return overlay.stroke(Color(UIColor.systemGreen), lineWidth: 2)
        }
        return overlay.stroke(Color(UIColor.systemRed), lineWidth: 2)
    }
    
}
