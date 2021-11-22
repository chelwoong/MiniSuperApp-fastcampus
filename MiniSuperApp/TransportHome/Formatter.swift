//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/22.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
