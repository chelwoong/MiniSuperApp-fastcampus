//
//  File.swift
//  
//
//  Created by woongs on 2021/12/06.
//

import Foundation
@testable import TopupImp
import XCTest
import SnapshotTesting
import FinanceEntity

final class CardOnFileViewTests: XCTestCase {
    
    func testCardOnFile() {
        // given
        let viewModels = [
            PaymentMethodViewModel(PaymentMethod(id: "0", name: "우라은행", digits: "**** 1111", color: "#3478f6ff", isPrimary: false)),
            PaymentMethodViewModel(PaymentMethod(id: "1", name: "현대은행", digits: "**** 2222", color: "#f19a38ff", isPrimary: false)),
            PaymentMethodViewModel(PaymentMethod(id: "2", name: "신한은행", digits: "**** 3333", color: "#78c5f5ff", isPrimary: false)),
        ]
        
        // when
        let sut = CardOnFileViewController()
        sut.update(with: viewModels)
        
        // then
        assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
    }
    
}
