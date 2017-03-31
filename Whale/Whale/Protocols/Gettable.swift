//
//  Gettable.swift
//  Whale
//
//  Created by fnord on 3/31/17.
//  Copyright © 2017 twof. All rights reserved.
//

import Foundation

public protocol Gettable {
    associatedtype Data
    
    func get(completionHandler: @escaping (Result<Data>) -> Void)
}
