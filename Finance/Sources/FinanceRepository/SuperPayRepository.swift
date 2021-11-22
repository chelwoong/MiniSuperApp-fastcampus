//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/15.
//

import Foundation
import Combine
import CombineUtil

public protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error>
}

public final class SuperPayRepositoryImp: SuperPayRepository {
    
    public var balance: ReadOnlyCurrentValuePublisher<Double> { self.balanceSubject }
    
    private let balanceSubject = CurrentValuePublisher<Double>(0)
    
    public func topup(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.bgQueue.async {
                Thread.sleep(forTimeInterval: 0.5)
                promise(.success(()))
                let newBalance = (self?.balanceSubject.value).map { $0 + amount }
                newBalance.map { self?.balanceSubject.send($0) }
            }
        }.eraseToAnyPublisher()
    }
    
    private let bgQueue = DispatchQueue(label: "topup.repositry.queue")
    
    public init() {
        
    }
}
