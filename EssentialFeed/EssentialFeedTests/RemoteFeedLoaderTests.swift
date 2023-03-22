//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Jancy on 3/5/23.
//

import XCTest
@testable import EssentialFeed



class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
        
    }
    
    func test_load_deliversErrorOnNon200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJSON = Data(bytes: "invalid.json".utf8)
                client.complete(withStatusCode: 200, data: invalidJSON)
        }
            
    }
 
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyList() {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = Data(bytes: "{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
//        var capturedResults = [RemoteFeedLoader.Result]()
//        sut.load { capturedResults.append($0)
//        }
//        let emptyListJSON = Data(bytes: "{\"items\": []}".utf8)
//        client.complete(withStatusCode: 200, data: emptyListJSON)
//        XCTAssertEqual(capturedResults, [.success([])])
    }
  
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { capturedResults.append($0) }
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    class HTTPClientSpy: HTTPClient {
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        private var messages = [(url: URL, completion: (HTTPClientResult)-> Void)]()
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int = 0, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
