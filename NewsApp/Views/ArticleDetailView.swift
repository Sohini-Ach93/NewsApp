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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder
                        Image("Placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)

                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)

                    case .failure:
                        // Fallback if image fails to load
                        Image("Placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                    @unknown default:
                        EmptyView()
                    }
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
            viewModel.fetchDetails(for: article)
        }
    }
}
