//
//  DeleteButton.swift
//  BookManagementApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI

struct DeleteButton: View {
    
    var buttonLabel: String
    var large: Bool = false
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "trash.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: large ? 25 : 20)
                Text(buttonLabel)
                    .font(large ? .title2 : .subheadline)
                    .fontWeight(large ? .bold : .semibold)
            }
            .foregroundStyle(Color(UIColor.systemRed))
        }
    }
    
}

//#Preview {
//    DeleteButton(buttonLabel: "Delete button")
//}
