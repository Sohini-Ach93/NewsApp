//
//  NewsCell.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct NewsCell: View {
    @ObservedObject var article: Article
    @StateObject private var imageLoader = ImageLoader()

    @ObservedObject var viewModel: NewsListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {

                // ✅ Correct image handling
                if let image = imageLoader.image {
                    image
                        .resizable()
                        .frame(width: 100, height: 120)
                        .cornerRadius(8)
                } else {
                    // Placeholder while loading
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 120)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        Text(article.title ?? "")
                            .font(.headline)
                            .lineLimit(2)
                        Spacer()

                        Button(action: {
                            viewModel.toggleBookmark(for: article)
                        }) {
                            Image(systemName: article.isBookmarked ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }

                    Text(article.description ?? "No description available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
        .onAppear {
            imageLoader.load(from: article.urlToImage)
        }
    }
}
