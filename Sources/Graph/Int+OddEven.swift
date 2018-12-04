//
//  Int+OddEven.swift
//  Graph
//
//  Created by Jack Maloney on 12/3/18.
//

import Foundation

extension Int {
    func even() -> Bool {
        return self % 2 == 0
    }
    
    func odd() -> Bool {
        return self % 2 == 1
    }
}
