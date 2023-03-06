//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Jancy on 3/5/23.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}
class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        _ = RemoteFeedLoader()
        let client = HTTPClient()
        
        XCTAssertNil(client.requestedURL)
    }
}
