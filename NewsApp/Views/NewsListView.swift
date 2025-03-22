//
//  NewsListView.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
import SwiftUI
struct NewsListView: View {
    @StateObject private var viewModel = NewsListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article)) {
                    NewsCell(article: article)
                }
            }
            .navigationTitle("Top Headlines")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}
