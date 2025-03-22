//
//  EndPoints.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
enum Endpoints {
    static let newsBaseURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(APIConstants.newsAPIKey)"

    static func articleDetailsURL(for articleID: String) -> String {
        return "https://internal-api.com/article-details/\(articleID)"
    }
    static func articleLikesURL(for articleID: String) -> String {
            return "https://cn-news-info-api.herokuapp.com/likes/\(articleID)"
        }

        static func articleCommentsURL(for articleID: String) -> String {
            return "https://cn-news-info-api.herokuapp.com/comments/\(articleID)"
        }

}
enum APIConstants {
    static let newsAPIKey = "8998c91ec339490598c5ddd068f466bd"
}
