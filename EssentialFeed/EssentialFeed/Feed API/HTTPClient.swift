//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Jancy on 3/28/23.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

