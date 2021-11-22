//
//  File.swift
//  
//
//  Created by woongs on 2021/11/22.
//

import Foundation
import ModernRIBs
import RIBsUtil
import FinanceEntity

public protocol AddPaymentMethodBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
}

public protocol AddPaymentMethodListener: AnyObject {
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}

