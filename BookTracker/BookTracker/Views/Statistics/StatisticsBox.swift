//
//  StatisticsBox.swift
//  BookManagementApp
//
//  Created by stud on 14/01/2025.
//

import SwiftUI

struct StatisticsBox<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(5)
        .multilineTextAlignment(.leading)
    }
}

//#Preview {
//    StatisticsBox() {
//        Text("Statistics Box")
//    }
//}
