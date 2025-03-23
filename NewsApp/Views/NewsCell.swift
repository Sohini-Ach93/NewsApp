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

    @ObservedObject var viewModel: NewsListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {

                AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder while loading
                        Image("Placeholder")
                            .resizable()
                            .frame(width: 100, height: 120)
                            .cornerRadius(8)

                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 100, height: 120)
                            .cornerRadius(8)

                    case .failure(_):
                        // Fallback image if loading fails
                        Image("Placeholder")
                            .resizable()
                            .frame(width: 100, height: 120)
                            .cornerRadius(8)

                    @unknown default:
                        EmptyView()
                    }
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
    }
}
