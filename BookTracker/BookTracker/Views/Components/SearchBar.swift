//
//  SearchBar.swift
//  BookManagementApp
//
//  Created by stud on 17/12/2024.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var text: String
    var placeholder: String = "Search..."

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(7)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(UIColor.systemGray))
                }
                .padding(.trailing, 10)
            }
        }
    }
    
}

//#Preview {
//    SearchBar(text: .constant(""))
//}
