//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Sohini Acharya on 22/03/25.
//

import Foundation

class NewsListViewModel: ObservableObject {
    @Published var articles: [Article] = []

    private let service = NewsAPIService()
    private let cacheFile = "cached_articles.json"
    private let bookmarkCacheFile = "bookmarked_articles.json"

    init() {
        loadArticlesFromCache()
        loadBookmarksFromCache() 
        fetchNews()
    }

    func fetchNews() {
        service.fetchTopHeadlines { [weak self] articles in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.articles = articles
                self.fetchLikesAndCommentsForArticles()
            }
        }
    }

    private func fetchLikesAndCommentsForArticles() {
        let group = DispatchGroup()

        for index in articles.indices {
            let articleID = articles[index].url
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "/", with: "-")

            group.enter()
            service.fetchArticleDetails(articleID: articleID) { [weak self] details in
                guard let self = self, let details = details else {
                    group.leave()
                    return
                }

                DispatchQueue.main.async {
                    var updatedArticle = self.articles[index]
                    updatedArticle.likes = details.likes
                    updatedArticle.comments = details.comments
                    self.articles[index] = updatedArticle
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.saveArticlesToCache() // Save only after all likes/comments are updated
            print(self.articles)
            let abc = self.articles
            print(self.articles)
        }
    }

    // MARK: - Caching

    private func getCacheURL() -> URL {
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDir.appendingPathComponent(cacheFile)
    }

    private func saveArticlesToCache() {
        let url = getCacheURL()
        do {
            let data = try JSONEncoder().encode(articles)
            try data.write(to: url)
        } catch {
            print("Error saving articles to cache:", error)
        }
    }

    private func loadArticlesFromCache() {
        let url = getCacheURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return }

        do {
            let data = try Data(contentsOf: url)
            let cachedArticles = try JSONDecoder().decode([Article].self, from: data)
            DispatchQueue.main.async {
                self.articles = cachedArticles
            }
        } catch {
            print("Error loading cached articles:", error)
        }
    }
    
    // MARK: - BookMarking
    func toggleBookmark(for article: Article) {
        article.isBookmarked.toggle()
        saveBookmarksToCache()
    }

    func getBookmarkedArticles() -> [Article] {
        return articles.filter { $0.isBookmarked }
    }
    
    private func getBookmarkCacheURL() -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(bookmarkCacheFile)
    }

    private func saveBookmarksToCache() {
        let bookmarked = articles.filter { $0.isBookmarked }
        do {
            let data = try JSONEncoder().encode(bookmarked)
            try data.write(to: getBookmarkCacheURL())
        } catch {
            print("Failed to save bookmarks:", error)
        }
    }

    private func loadBookmarksFromCache() {
        let url = getBookmarkCacheURL()
        guard FileManager.default.fileExists(atPath: url.path) else { return }

        do {
            let data = try Data(contentsOf: url)
            let bookmarked = try JSONDecoder().decode([Article].self, from: data)
            for bookmarkedArticle in bookmarked {
                if let index = articles.firstIndex(where: { $0.url == bookmarkedArticle.url }) {
                    articles[index].isBookmarked = true
                }
            }
        } catch {
            print("Failed to load bookmarks:", error)
        }
    }
}
