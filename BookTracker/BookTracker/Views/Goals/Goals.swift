//
//  Goals.swift
//  BookManagementApp
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct Goals: View {
    
    @EnvironmentObject private var goalService: GoalService
    @State private var showFinishedGoals: Bool = false
    
    @State private var showingSheet: Bool = false
    @State private var goalName: String = ""
    @State private var booksToRead: String = ""
    @State private var finishDate: Date = Date()
    
    var body: some View {
        let goals = showFinishedGoals
            ? goalService.activeGoals + goalService.finishedGoals
            : goalService.activeGoals
        
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center) {
                        Text("Goals")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if !goals.isEmpty {
                            AddButton(buttonLabel: "Add goal", action: {
                                goalName = ""
                                booksToRead = ""
                                finishDate = Date()
                                showingSheet = true
                            })
                        }
                    }
                    
                    Toggle(isOn: $showFinishedGoals) {
                        HStack {
                            Spacer()
                            Text("Show finished goals")
                                .font(.title3)
                        }
                    }
                }
                .padding(.bottom, 5)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(goals, id: \.objectID) { goal in
                            GoalPreview(goal)
                                .environmentObject(goalService)
                        }
                        .transition(.slide)
                        .animation(.easeInOut, value: goals)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(10)
            
            if goals.isEmpty {
                VStack(spacing: 20) {
                    Text("You have no active goals")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    AddButton(buttonLabel: "Add goal", large: true, action: {
                        goalName = ""
                        booksToRead = ""
                        finishDate = Date()
                        showingSheet = true
                    })
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Goals")
        .navigationBarHidden(true)
        .sheet(isPresented: $showingSheet) {
            NewGoalSheet(
                goalName: $goalName,
                booksToRead: $booksToRead,
                finishDate: $finishDate,
                showingSheet: $showingSheet,
                onSave: validateGoal
            )
        }
    }
    
    private func validateGoal(goalName: String, booksToRead: String, finishDate: Date) {
        let validationResult = goalService.validateGoal(
            name: goalName,
            booksToRead: booksToRead,
            finishDate: finishDate
        )
        showingSheet = !validationResult
    }
    
}
