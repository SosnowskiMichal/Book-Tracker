//
//  FormatterService.swift
//  BookManagementApp
//
//  Created by stud on 07/01/2025.
//

import Foundation

class FormatterService {
    
    static let shared = FormatterService()
    
    private init() {}
    
    func formatDate(_ dateToFormat: Date?) -> String? {
        guard let dateToFormat = dateToFormat else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: dateToFormat)
    }
    
}
