//
//  BookStatus.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//

import SwiftUI

struct BookStatus: View {
    
    var statusLabel: String
    var large: Bool = false
    var onTap: () -> Void = {}
    
    var body: some View {
        Text(statusLabel)
            .font(large ? .title3 : .subheadline)
            .fontWeight(.semibold)
            .padding(large ? 6 : 4)
            .foregroundStyle(Color(UIColor.systemGray))
            .background(
                RoundedRectangle(cornerRadius: large ? 6 : 4)
                    .stroke(Color(UIColor.systemGray), lineWidth: large ? 3 : 2)
            )
            .onTapGesture {
                onTap()
            }
    }
    
}

//#Preview {
//    VStack(spacing: 20) {
//        BookStatus(statusLabel: "Test")
//        BookStatus(statusLabel: "Test", large: true)
//    }
//}
