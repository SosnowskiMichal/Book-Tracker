//
//  AddButton.swift
//  BookManagementApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI

struct AddButton: View {
    
    var buttonLabel: String
    var large: Bool = false
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: large ? 25 : 20)
                Text(buttonLabel)
                    .font(large ? .title2 : .subheadline)
                    .fontWeight(large ? .bold : .semibold)
            }
            .foregroundStyle(Color(UIColor.systemGray))
        }
    }
    
}

//#Preview {
//    AddButton(buttonLabel: "Add button")
//}
