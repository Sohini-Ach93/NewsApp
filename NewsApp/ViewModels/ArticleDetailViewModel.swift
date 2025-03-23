//
//  ArticleDetailViewModel.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation

class ArticleDetailViewModel: ObservableObject {
    @Published var details: ArticleDetails?
    private let service: NewsAPIServiceProtocol

        init(service: NewsAPIServiceProtocol = NewsAPIService()) {
            self.service = service
        }


    func fetchDetails(for article: Article) {
        let articleID = getArticleID(from: article)
        
        // Try loading from cache first
        if let cached = loadDetailsFromCache(articleID: articleID) {
            self.details = cached
        }

        // Then try fetching from API (will update the cache if successful)
        service.fetchArticleDetails(articleID: articleID) { [weak self] fetchedDetails in
            guard let self = self, let fetchedDetails = fetchedDetails else { return }
            DispatchQueue.main.async {
                self.details = fetchedDetails
                self.saveDetailsToCache(details: fetchedDetails, articleID: articleID)
            }
        }
    }

    // MARK: - Helper

    private func getArticleID(from article: Article) -> String {
        article.url
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "/", with: "-")
    }

    // MARK: - Caching

    private func getCacheURL(for articleID: String) -> URL {
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDir.appendingPathComponent("article_detail_\(articleID).json")
    }

    private func saveDetailsToCache(details: ArticleDetails, articleID: String) {
        let url = getCacheURL(for: articleID)
        do {
            let data = try JSONEncoder().encode(details)
            try data.write(to: url)
        } catch {
            print("Error saving article details to cache:", error)
        }
    }

    private func loadDetailsFromCache(articleID: String) -> ArticleDetails? {
        let url = getCacheURL(for: articleID)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ArticleDetails.self, from: data)
        } catch {
            print("Error loading cached article details:", error)
            return nil
        }
    }
}
