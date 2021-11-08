//
//  Array+Utills.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
