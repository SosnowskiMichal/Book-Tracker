//
//  SearchService.swift
//  BookManagementApp
//
//  Created by stud on 21/01/2025.
//

import Foundation

class SearchService: ObservableObject {
    
    private var lastSearchPrompt: String?
    private var pageNumber = 1
    
    func getBooks(_ searchPrompt: String) async -> [ApiBook]? {
        let normalizedSearchPrompt = normalizeSearchPrompt(searchPrompt)
        
        if lastSearchPrompt != normalizedSearchPrompt {
            lastSearchPrompt = normalizedSearchPrompt
            pageNumber = 1
        } else {
            pageNumber += 1
        }
        
        if normalizedSearchPrompt == "" {
            return [ApiBook]()
        }
        
        let urlString = "https://openlibrary.org/search.json?q=\(normalizedSearchPrompt)+language:eng&fields=key,title,author_name,cover_i,first_publish_year&lang=en&page=\(pageNumber)&limit=5"
        let url = URL(string: urlString)
        
        if let url = url {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            
            do {
                let (data, _) = try await session.data(for: request)
                
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(ApiResponse.self, from: data)
                return apiResponse.docs
            }
            catch {
                print("Cannot download books from API: \(error)")
                return nil
            }
        }
        
        return [ApiBook]()
    }
    
    private func normalizeSearchPrompt(_ searchPrompt: String) -> String {
        return searchPrompt.replacingOccurrences(of: " ", with: "+").lowercased()
    }
    
    func getBookDescription(_ key: String) async -> String? {
        let urlString = "https://openlibrary.org/\(key).json"
        let url = URL(string: urlString)
        
        if let url = url {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            
            do {
                let (data, _) = try await session.data(for: request)
                let decoder = JSONDecoder()
                
                if let apiResponseString = try? decoder.decode(ApiWorkString.self, from: data) {
                    return apiResponseString.description
                }
                
                if let apiResponseObject = try? decoder.decode(ApiWorkObject.self, from: data) {
                    return apiResponseObject.description?.value
                }
                
                return nil
                
            }
            catch {
                print("Cannot download book description from API: \(error)")
                return nil
            }
        }
        
        return nil
    }
    
    func getPageNumber() -> Int {
        return pageNumber
    }
    
}
