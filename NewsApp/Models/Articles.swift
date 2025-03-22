//
//  Articles.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
class Article: ObservableObject, Identifiable, Codable {
    var id: String {
        URL(string: url)?.host?.replacingOccurrences(of: ".", with: "-") ?? UUID().uuidString
    }

    let title: String?
    let description: String?
    let author: String?
    let url: String
    let urlToImage: String?

    @Published var likes: Int?
    @Published var comments: Int?

    // MARK: - Coding

    private enum CodingKeys: String, CodingKey {
        case title, description, author, url, urlToImage, likes, comments
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        url = try container.decode(String.self, forKey: .url)
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        likes = try container.decodeIfPresent(Int.self, forKey: .likes)
        comments = try container.decodeIfPresent(Int.self, forKey: .comments)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(urlToImage, forKey: .urlToImage)
        try container.encodeIfPresent(likes, forKey: .likes)
        try container.encodeIfPresent(comments, forKey: .comments)
    }
}

struct ArticleDetails: Codable {
    let likes: Int
    let comments: Int
}
