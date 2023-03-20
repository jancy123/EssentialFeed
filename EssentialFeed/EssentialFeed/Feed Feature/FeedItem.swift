//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Jancy on 3/4/23.
//

import Foundation


public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
