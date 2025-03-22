//
//  NewsCell.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
import SwiftUI

struct NewsCell: View {
    @ObservedObject var article: Article
    @StateObject private var imageLoader = ImageLoader()
    
    // Inject the view model so you can call toggleBookmark
    @ObservedObject var viewModel: NewsListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                imageLoader.image?
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .onAppear {
                        imageLoader.load(from: article.urlToImage)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(article.title ?? "")
                            .font(.headline)
                            .lineLimit(2)
                        Spacer()

                        // ✅ Bookmark icon
                        Button(action: {
                            viewModel.toggleBookmark(for: article)
                        }) {
                            Image(systemName: article.isBookmarked ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }

                    Text(article.description ?? "No description")
                        .font(.subheadline)
                        .lineLimit(2)

                    Text("By: \(article.author ?? "Unknown")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            if let likes = article.likes, let comments = article.comments {
                HStack {
                    Text("❤️ \(likes)")
                    Spacer()
                    Text("💬 \(comments)")
                }
                .font(.caption)
                .padding(.top, 4)
            } else {
                Text("Loading likes/comments…")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}
