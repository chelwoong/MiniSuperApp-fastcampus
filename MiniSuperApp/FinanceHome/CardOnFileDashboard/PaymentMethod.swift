//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import Foundation

struct PaymentMethod: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
