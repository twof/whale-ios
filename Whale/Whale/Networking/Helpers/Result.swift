//
//  Result.swift
//  Whale
//
//  Created by fnord on 3/31/17.
//  Copyright © 2017 twof. All rights reserved.
//

public enum Result<T> {
    case Success(T)
    case Failure(Error)
}
