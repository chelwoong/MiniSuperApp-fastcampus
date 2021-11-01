//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import UIKit

struct PaymentMethodViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    init(_ paymentMethod: PaymentMethod) {
        self.name = paymentMethod.name
        self.digits = "**** \(paymentMethod.digits)"
        self.color = UIColor(hex: paymentMethod.color) ?? .systemGray
    }
}
