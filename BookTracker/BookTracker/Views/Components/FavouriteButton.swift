//
//  FavouriteButton.swift
//  BookManagementApp
//
//  Created by stud on 19/11/2024.
//

import SwiftUI

struct FavouriteButton: View {
    
    @Binding var isSet: Bool
    var iconSize: CGFloat = 25
    var action: () -> Void = {}
    
    var body: some View {
        Button {
            isSet.toggle()
            action()
        } label: {
            Image(systemName: isSet ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color(UIColor.systemGray))
                .frame(width: iconSize)
        }
    }
    
}

//#Preview {
//    FavouriteButton(isSet: .constant(true))
//}
