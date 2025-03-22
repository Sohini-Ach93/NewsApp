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

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                imageLoader.image?
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .onAppear {
                        imageLoader.load(from: article.urlToImage)
                    }

                VStack(alignment: .leading) {
                    Text(article.title ?? "").bold()
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
    }
}
