//
//  File.swift
//  
//
//  Created by woongs on 2021/12/02.
//

import Foundation
@testable import TopupImp
import RIBsTestSupport
import FinanceEntity

final class CardOnFileBuildableMock: CardOnFileBuildable {
    
    var buildHandler: ((_ listener: CardOnFileListener) -> CardOnFileRouting)?
    
    var buildCallCount = 0
    var buildPaymentMethods: [PaymentMethod]?
    func build(withListener listener: CardOnFileListener, paymentMethods: [PaymentMethod]) -> CardOnFileRouting {
        self.buildCallCount += 1
        self.buildPaymentMethods = paymentMethods
        
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        
        fatalError()
    }
}

final class CardOnFileRoutingMock: ViewableRoutingMock, CardOnFileRouting {
    
}
