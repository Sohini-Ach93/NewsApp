//
//  ArticleDetailView.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @StateObject private var viewModel = ArticleDetailViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(article.title ?? "").font(.title).bold()
            Text(article.description ?? "No description")
            Text("By: \(article.author ?? "Unknown")")

            if let details = viewModel.details {
                HStack {
                    Text("Likes: \(details.likes)")
                    Spacer()
                    Text("Comments: \(details.comments)")
                }
            } else {
                Text("Loading details...")
            }

            Spacer()
        }
        .padding()
        .onAppear { viewModel.fetchDetails(for: article) }
    }
}
