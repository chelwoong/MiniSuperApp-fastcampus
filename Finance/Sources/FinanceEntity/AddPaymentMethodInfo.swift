//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import Foundation

public struct AddPaymentInfo {
    public let number: String
    public let cvc: String
    public let expiration: String
    
    public init(
        number: String,
        cvc: String,
        expiration: String
    ) {
        self.number = number
        self.cvc = cvc
        self.expiration = expiration
    }
}
