//
//  File.swift
//  
//
//  Created by woongs on 2021/12/02.
//

import Foundation
import FinanceRepository
import CombineUtil
import Combine
import FinanceEntity

public final class CardOnFileRepositoryMock: CardOnFileRepository {
    
    public var cardOnFileSubject = CurrentValuePublisher<[PaymentMethod]>([])
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { self.cardOnFileSubject }
    
    public var addCardCallCount = 0
    public var addCardInfo: AddPaymentInfo?
    public var addedPaymentMethod: PaymentMethod?
    public func addCard(info: AddPaymentInfo) -> AnyPublisher<PaymentMethod, Error> {
        addCardCallCount += 1
        addCardInfo = info
        
        if let addedPaymentMethod = self.addedPaymentMethod {
            return Just(addedPaymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "CardOnFileRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    var fetchCallCount = 0
    public func fetch() {
        self.fetchCallCount += 1
    }
    
    public init() {
        
    }
}
