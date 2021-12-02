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

public final class SuperPayRepositoryMock: SuperPayRepository {
    
    public var balanceSubject = CurrentValuePublisher<Double>(0)
    public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
    
    public var topupCallCount = 0
    public var topupAmount: Double?
    public var paymentMethodID: String?
    public var shouldTopupSucceed: Bool = true
    public func topup(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error> {
        self.topupCallCount += 1
        self.topupAmount = amount
        self.paymentMethodID = paymentMethodId
        
        if shouldTopupSucceed {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "SuperPayRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    public init() {
        
    }
}
