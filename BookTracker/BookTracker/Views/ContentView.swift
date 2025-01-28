//
//  ContentView.swift
//  BookManagementApp
//
//  Created by stud on 05/11/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = .books
    
    enum Tab {
        case books
        case collections
        case goals
        case search
        case statistics
    }
    
    @StateObject private var bookService: BookService
    @StateObject private var collectionService: CollectionService
    @StateObject private var goalService: GoalService
    @StateObject private var searchService: SearchService
    
    init() {
        let goalService = GoalService()
        let collectionService = CollectionService()
        let searchService = SearchService()
        let bookService = BookService(goalService, searchService)
        
        _goalService = StateObject(wrappedValue: goalService)
        _collectionService = StateObject(wrappedValue: collectionService)
        _bookService = StateObject(wrappedValue: bookService)
        _searchService = StateObject(wrappedValue: searchService)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Books()
                    .environmentObject(bookService)
                    .environmentObject(collectionService)
            }
            .tabItem {
                Label("Books", systemImage: "book")
            }
            .tag(Tab.books)
            
            NavigationView {
                Collections()
                    .environmentObject(collectionService)
                    .environmentObject(bookService)
            }
            .tabItem {
                Label("Collections", systemImage: "rectangle.stack")
            }
            .tag(Tab.collections)
            
            NavigationView {
                Goals()
                    .environmentObject(goalService)
            }
            .tabItem {
                Label("Goals", systemImage: "flag")
            }
            .tag(Tab.goals)
            
            NavigationView {
                Search()
                    .environmentObject(searchService)
                    .environmentObject(bookService)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search)
            
            NavigationView {
                Statistics()
            }
            .tabItem {
                Label("Statistics", systemImage: "chart.bar")
            }
            .tag(Tab.statistics)
        }
        .accentColor(Color.primary)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

