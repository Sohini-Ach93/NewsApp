//
//  ArticleDetailView.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @StateObject private var viewModel = ArticleDetailViewModel()
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // ✅ Load and show image
                if let image = imageLoader.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .cornerRadius(10)
                }

                // ✅ Article details
                Text(article.title ?? "")
                    .font(.title)
                    .bold()

                Text(article.description ?? "No description")
                    .font(.body)

                Text("By: \(article.author ?? "Unknown")")
                    .font(.caption)
                    .foregroundColor(.gray)

                if let details = viewModel.details {
                    HStack {
                        Text("❤️ Likes: \(details.likes)")
                        Spacer()
                        Text("💬 Comments: \(details.comments)")
                    }
                    .font(.subheadline)
                } else {
                    Text("Loading details…")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Article")
        .onAppear {
            imageLoader.load(from: article.urlToImage)
            viewModel.fetchDetails(for: article)
        }
    }
}
