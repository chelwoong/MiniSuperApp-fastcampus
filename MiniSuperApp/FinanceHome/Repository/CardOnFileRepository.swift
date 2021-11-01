//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import Foundation

protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
    
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { self.paymentMethodSubject }
    
    private let paymentMethodSubject = CurrentValuePublisher<[PaymentMethod]>([
        PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentMethod(id: "1", name: "신한은행", digits: "0523", color: "#3478f6ff", isPrimary: false),
        PaymentMethod(id: "2", name: "국민은행", digits: "0323", color: "#78c5f5ff", isPrimary: false),
        PaymentMethod(id: "3", name: "삼성은행", digits: "0423", color: "#65c466ff", isPrimary: false),
        PaymentMethod(id: "4", name: "현대은행", digits: "0623", color: "#ffcc00ff", isPrimary: false),
    ])
}
