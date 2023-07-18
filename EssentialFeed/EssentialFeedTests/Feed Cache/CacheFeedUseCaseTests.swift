//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Jancy on 7/17/23.
//

import XCTest

class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}
class FeedStore {
    var deleteCachedFeedCallCount = 0
}
class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
