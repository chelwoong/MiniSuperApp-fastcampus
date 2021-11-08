//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import Foundation
import Combine

protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentInfo) -> AnyPublisher<PaymentMethod, Error>
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
    
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { self.paymentMethodsSubject }
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
//        PaymentMethod(id: "1", name: "신한은행", digits: "0523", color: "#3478f6ff", isPrimary: false),
//        PaymentMethod(id: "2", name: "국민은행", digits: "0323", color: "#78c5f5ff", isPrimary: false),
//        PaymentMethod(id: "3", name: "삼성은행", digits: "0423", color: "#65c466ff", isPrimary: false),
//        PaymentMethod(id: "4", name: "현대은행", digits: "0623", color: "#ffcc00ff", isPrimary: false),
    ])
    
    func addCard(info: AddPaymentInfo) -> AnyPublisher<PaymentMethod, Error> {
        let paymentMethod = PaymentMethod(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
        
        var new = self.paymentMethodsSubject.value
        new.append(paymentMethod)
        self.paymentMethodsSubject.send(new)
        
        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
