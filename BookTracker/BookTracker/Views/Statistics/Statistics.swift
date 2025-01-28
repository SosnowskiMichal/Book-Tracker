//
//  Statistics.swift
//  BookManagementApp
//
//  Created by stud on 12/11/2024.
//

import SwiftUI

struct StatisticsData {
    var numberOfBooks: Int = 0
    var bookStatusesInfo: (Int, Int, Int) = (0, 0, 0)
    var booksReadInLast30Days: Int = 0
    var lastReadBook: (String?, String?) = (nil, nil)
    var lastAddedBook: (String?, String?) = (nil, nil)
    var goalsInfo: (Int, Int, Int) = (0, 0, 0)
    var numberOfCollections: Int = 0
}

struct Statistics: View {
    
    private var statisticsService = StatisticsService()
    @State private var statisticsData = StatisticsData()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 15) {
                        StatisticsBox {
                            Text("You have ")
                                .font(.title3)
                            + Text("\(statisticsData.numberOfBooks)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" book\(statisticsData.numberOfBooks != 1 ? "s" : "")")
                                .font(.title3)
                        }
                        
                        let (wantToRead, reading, read) = statisticsData.bookStatusesInfo
                        StatisticsBox {
                            Text("You are currently reading ")
                                .font(.title3)
                            + Text("\(reading)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" book\(wantToRead != 1 ? "s" : "")")
                                .font(.title3)

                            Text("You've read ")
                                .font(.title3)
                            + Text("\(read)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" book\(wantToRead != 1 ? "s" : "") so far")
                                .font(.title3)

                            Text("You want to read ")
                                .font(.title3)
                            + Text("\(wantToRead)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" book\(wantToRead != 1 ? "s" : "")")
                                .font(.title3)
                        }
                        
                        StatisticsBox {
                            Text("You've read ")
                                .font(.title3)
                            + Text("\(statisticsData.booksReadInLast30Days)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" book\(statisticsData.booksReadInLast30Days != 1 ? "s" : "") in the last 30 days")
                                .font(.title3)
                        }
                        
                        let (lastReadBookTitle, lastReadBookAuthor) = statisticsData.lastReadBook
                        if let lastReadBookTitle = lastReadBookTitle, let lastReadBookAuthor = lastReadBookAuthor {
                            StatisticsBox {
                                Text("The last book you read was ")
                                    .font(.title3)
                                
                                Text("\(lastReadBookTitle)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                + Text(" by ")
                                    .font(.title3)
                                + Text("\(lastReadBookAuthor)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        let (lastAddedBookTitle, lastAddedBookAuthor) = statisticsData.lastAddedBook
                        if let lastAddedBookTitle = lastAddedBookTitle, let lastAddedBookAuthor = lastAddedBookAuthor {
                            StatisticsBox {
                                Text("The last book you recently added was ")
                                    .font(.title3)
                                
                                Text("\(lastAddedBookTitle)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                + Text(" by ")
                                    .font(.title3)
                                + Text("\(lastAddedBookAuthor)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        }
                        
                        let (active, completed, notCompleted) = statisticsData.goalsInfo
                        StatisticsBox {
                            Text("You have ")
                                .font(.title3)
                            + Text("\(active)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" ongoing goal\(wantToRead != 1 ? "s" : "")")
                                .font(.title3)

                            Text("You've completed ")
                                .font(.title3)
                            + Text("\(completed)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" goal\(wantToRead != 1 ? "s" : "") so far")
                                .font(.title3)

                            Text("You've not completed ")
                                .font(.title3)
                            + Text("\(notCompleted)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" goal\(wantToRead != 1 ? "s" : "")")
                                .font(.title3)
                        }
                        
                        StatisticsBox {
                            Text("You have ")
                                .font(.title3)
                            + Text("\(statisticsData.numberOfCollections)")
                                .font(.title2)
                                .fontWeight(.bold)
                            + Text(" collection\(statisticsData.numberOfCollections != 1 ? "s" : "")")
                                .font(.title3)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(10)
        }
        .navigationTitle("Statistics")
        .navigationBarHidden(true)
        .onAppear {
            updateData()
        }
    }
    
    private func updateData() {
        statisticsData.numberOfBooks = statisticsService.getNumberOfBooks()
        statisticsData.bookStatusesInfo = statisticsService.getBookStatusesInfo()
        statisticsData.booksReadInLast30Days = statisticsService.getBooksReadInLast30Days()
        statisticsData.lastReadBook = statisticsService.getLastReadBook()
        statisticsData.lastAddedBook = statisticsService.getLastAddedBook()
        statisticsData.goalsInfo = statisticsService.getGoalsInfo()
        statisticsData.numberOfCollections = statisticsService.getNumberOfCollections()
    }
    
}
