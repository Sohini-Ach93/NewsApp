//
//  NewsAPIService.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation
class NewsAPIService {
    func fetchTopHeadlines(completion: @escaping ([Article]) -> Void) {
        APIClient.shared.request(urlString: Endpoints.newsBaseURL) { (result: Result<ArticleResponse, Error>) in
            switch result {
            case .success(let response):
                completion(response.articles)
            case .failure:
                completion([])
            }
        }
    }

    func fetchArticleDetails(articleID: String, completion: @escaping (ArticleDetails?) -> Void) {
        let group = DispatchGroup()
        var likes: Int = 0
        var comments: Int = 0

        group.enter()
        APIClient.shared.request(urlString: Endpoints.articleLikesURL(for: articleID)) { (result: Result<Int, Error>) in
            if case .success(let value) = result { likes = value }
            group.leave()
        }

        group.enter()
        APIClient.shared.request(urlString: Endpoints.articleCommentsURL(for: articleID)) { (result: Result<Int, Error>) in
            if case .success(let value) = result { comments = value }
            group.leave()
        }

        group.notify(queue: .main) {
            completion(ArticleDetails(likes: likes, comments: comments))
        }
    }
}
