//
//  Articles.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
class Article: Codable, Identifiable, ObservableObject {
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
    @Published var isBookmarked: Bool = false  // ✅ Add this

    private enum CodingKeys: String, CodingKey {
        case title, description, author, url, urlToImage
    }

    // Required to encode/decode @Published properties manually
    enum AdditionalKeys: String, CodingKey {
        case likes, comments, isBookmarked
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        author = try container.decodeIfPresent(String.self, forKey: .author)
        url = try container.decode(String.self, forKey: .url)
        urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)

        let additional = try decoder.container(keyedBy: AdditionalKeys.self)
        likes = try additional.decodeIfPresent(Int.self, forKey: .likes)
        comments = try additional.decodeIfPresent(Int.self, forKey: .comments)
        isBookmarked = try additional.decodeIfPresent(Bool.self, forKey: .isBookmarked) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(author, forKey: .author)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(urlToImage, forKey: .urlToImage)

        var additional = encoder.container(keyedBy: AdditionalKeys.self)
        try additional.encodeIfPresent(likes, forKey: .likes)
        try additional.encodeIfPresent(comments, forKey: .comments)
        try additional.encode(isBookmarked, forKey: .isBookmarked)
    }
}

struct ArticleDetails: Codable {
    let likes: Int
    let comments: Int
}
