//
//  ChangeBookStatusSheet.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//

import SwiftUI

import SwiftUI

struct ChangeBookStatusSheet: View {
    
    @Binding var selectedStatus: String
    @Binding var showingSheet: Bool
    var onSave: (String) -> Void
    
    let options = ["Want to read", "Reading", "Read"]
    
    var body: some View {
        Form {
            Section(header: Text("Select book status")) {
                List(options, id: \.self) { option in
                    HStack(alignment: .center, spacing: 10) {
                        if selectedStatus == option {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundStyle(Color(UIColor.systemBlue))
                        } else {
                            Image(systemName: "square")
                        }
                        
                        Text(option)
                            .font(.body)
                            .foregroundStyle(
                                selectedStatus == option
                                ? Color(UIColor.systemBlue)
                                : Color.primary
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedStatus = option
                    }
                }
            }
            
            Section {
                HStack {
                    Button("Save") {
                        onSave(selectedStatus)
                        showingSheet = false
                    }
                    .disabled(selectedStatus.isEmpty)
                    
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

#Preview {
    ChangeBookStatusSheet(
        selectedStatus: .constant(""),
        showingSheet: .constant(true),
        onSave: { _ in }
    )
}
