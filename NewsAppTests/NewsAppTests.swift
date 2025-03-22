//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Sohini Acharya on 22/03/25.
//

import XCTest
@testable import NewsApp

final class NewsAppTests: XCTestCase {
    var viewModel: NewsListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = NewsListViewModel()
    }

    func testFetchNewsPopulatesArticles() {
        let expectation = expectation(description: "Articles fetched")

        viewModel.fetchNews()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertFalse(self.viewModel.articles.isEmpty, "Articles should not be empty after fetch")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
    
    func testToggleBookmarkTogglesStateCorrectly() {
        let article = Article(
            title: "Test Article",
            description: "A test description",
            author: "Author",
            url: "https://example.com/test",
            urlToImage: nil
        )

        // Manually inject the article to the list
        viewModel.articles = [article]

        viewModel.toggleBookmark(for: article)
        XCTAssertTrue(viewModel.isBookmarked(article), "Article should be bookmarked")

        viewModel.toggleBookmark(for: article)
        XCTAssertFalse(viewModel.isBookmarked(article), "Article should be unbookmarked")
    }
    
    func testGetBookmarkedArticlesReturnsCorrectResults() {
        let article1 = Article(title: "A1", description: nil, author: nil, url: "https://a1.com", urlToImage: nil)
        let article2 = Article(title: "A2", description: nil, author: nil, url: "https://a2.com", urlToImage: nil)
        
        article2.isBookmarked = true
        
        viewModel.articles = [article1, article2]
        
        let bookmarked = viewModel.getBookmarkedArticles()
        
        XCTAssertEqual(bookmarked.count, 1, "Only one article should be bookmarked")
        XCTAssertEqual(bookmarked.first?.url, article2.url, "Bookmarked article should match")
    }
    
    func testLikesAndCommentsAreFetchedForMockArticles() {
        let mockService = MockNewsAPIService()
        let viewModel = NewsListViewModel(service: mockService)

        let article1 = Article(title: "Mock 1", description: nil, author: nil, url: "https://mock.com/1", urlToImage: nil)
        let article2 = Article(title: "Mock 2", description: nil, author: nil, url: "https://mock.com/2", urlToImage: nil)
        viewModel.articles = [article1, article2]

        let expectation = XCTestExpectation(description: "Likes/comments fetched")

        viewModel.fetchLikesAndCommentsForArticles()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let allPopulated = viewModel.articles.allSatisfy {
                $0.likes != nil && $0.comments != nil
            }
            XCTAssertTrue(allPopulated, "Each article should have likes and comments populated")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 4)
    }
}
class MockNewsAPIService: NewsAPIServiceProtocol {
    func fetchArticleDetails(articleID: String, completion: @escaping (ArticleDetails?) -> Void) {
        // Provide mock details for testing
        let mockDetails = ArticleDetails(likes: Int.random(in: 10...100), comments: Int.random(in: 0...50))
        completion(mockDetails)
    }

    func fetchTopHeadlines(completion: @escaping ([Article]) -> Void) {
        // Optionally override if you ever call it in tests
        completion([])
    }
}
