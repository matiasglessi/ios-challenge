//
//  Result.swift
//  ios-challenge
//
//  Created by Matias Glessi on 05/10/2020.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
