//
//  NewNoteSheet.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//

import SwiftUI

struct NewNoteSheet: View {
    
    @Binding var noteContent: String
    @Binding var showingSheet: Bool
    var onSave: (String) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Add new book note")) {
                TextField("Note content", text: $noteContent)
            }
            
            Section {
                HStack {
                    Button("Save note") {
                        onSave(noteContent)
                        showingSheet = false
                    }
                    .disabled(
                        noteContent.isEmpty
                        || noteContent.count > 500
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
//    NewNoteSheet(
//        noteContent: .constant(""),
//        showingSheet: .constant(true),
//        onSave: { _ in }
//    )
//}
