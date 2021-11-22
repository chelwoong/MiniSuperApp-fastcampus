//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/10/30.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
