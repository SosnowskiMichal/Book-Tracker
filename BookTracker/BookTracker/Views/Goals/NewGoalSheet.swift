//
//  NewGoalSheet.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

struct NewGoalSheet: View {
    
    @Binding var goalName: String
    @Binding var booksToRead: String
    @Binding var finishDate: Date
    @Binding var showingSheet: Bool
    var onSave: (String, String, Date) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Add new goal")) {
                TextField("Goal name", text: $goalName)
                
                TextField("Books to read", text: $booksToRead)
                    .keyboardType(.numberPad)
                    .onChange(of: booksToRead) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            booksToRead = filtered
                        }
                    }
                
                DatePicker("Finish date", selection: $finishDate, displayedComponents: .date)
            }
            
            Section {
                HStack {
                    Button("Save goal") {
                        onSave(goalName, booksToRead, finishDate)
                        showingSheet = false
                    }
                    .disabled(
                        goalName.isEmpty
                        || goalName.count > 50
                        || booksToRead.isEmpty
                        || Int(booksToRead) == 0
                        || finishDate < Date()
                    )
                    
                    Spacer()
                    
                    Button("Cancel") {
                        showingSheet = false
                    }
                    .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
    
}

//#Preview {
//    NewGoalSheet(
//        goalName: .constant(""),
//        booksToRead: .constant(""),
//        finishDate: .constant(Date.now),
//        showingSheet: .constant(true),
//        onSave: {_,_,_ in }
//    )
//}
