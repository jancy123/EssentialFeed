//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jancy on 3/4/23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
