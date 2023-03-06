//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Jancy on 3/4/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping () -> Void)
}
