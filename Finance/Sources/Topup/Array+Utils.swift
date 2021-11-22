//
//  File.swift
//  
//
//  Created by woongs on 2021/11/22.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
