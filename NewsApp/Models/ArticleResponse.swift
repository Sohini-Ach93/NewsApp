//
//  ArticleResponse.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
struct ArticleResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
