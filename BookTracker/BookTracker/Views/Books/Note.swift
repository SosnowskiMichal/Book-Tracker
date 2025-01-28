//
//  Note.swift
//  BookManagementApp
//
//  Created by stud on 19/11/2024.
//

import SwiftUI

struct Note: View {
    
    @ObservedObject var bookNote: BookNote
    @EnvironmentObject var bookService: BookService
    
    @State private var showingAlert: Bool = false
    
    init(_ bookNote: BookNote) {
        self.bookNote = bookNote
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(bookNote.content ?? "")
                .font(.subheadline)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            HStack(alignment: .bottom) {
                if let formattedDateAdded = FormatterService.shared.formatDate(bookNote.dateAdded) {
                    Text(formattedDateAdded)
                        .font(.caption)
                        .italic()
                        .foregroundStyle(Color(UIColor.systemGray))
                }
                
                Spacer()
                
                DeleteButton(buttonLabel: "Remove", action: {
                    showingAlert = true
                })
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(5)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Remove this note?"),
                primaryButton: .destructive(Text("Remove")) {
                    bookService.deleteNote(bookNote.book!, bookNote)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
}
