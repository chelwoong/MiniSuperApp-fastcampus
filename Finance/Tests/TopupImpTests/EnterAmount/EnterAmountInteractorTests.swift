//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/12/02.
//

@testable import TopupImp
import XCTest
import FinanceEntity
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {

    // system under test
    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!
    
    private var repository: SuperPayRepositoryMock! {
        return dependency.superPayRepository as? SuperPayRepositoryMock
    }

    // TODO: declare other objects and mocks you need as private vars

    override func setUp() {
        super.setUp()
        
        self.presenter = EnterAmountPresentableMock()
        self.dependency = EnterAmountDependencyMock()
        self.listener = EnterAmountListenerMock()

        self.sut = EnterAmountInteractor(
            presenter: self.presenter,
            dependency: self.dependency
        )
        self.sut.listener = self.listener
    }

    // MARK: - Tests
    func testActivate() {
        // given
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#13ABE8FF",
            isPrimary: false
        )
        self.dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when
        self.sut.activate()
        
        // then
        XCTAssertEqual(self.presenter.updateSelectedPaymentMethodCallCount, 1)
        XCTAssertEqual(self.presenter.updateSelectedPaymentMethodViewModel?.name, "name_0 9999")
        XCTAssertNotNil(self.presenter.updateSelectedPaymentMethodViewModel?.image)
    }
    
    func testTopupWithValidAmount() {
        // given
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#13ABE8FF",
            isPrimary: false
        )
        self.dependency.selectedPaymentMethodSubject.send(paymentMethod)
        
        // when
        self.sut.didTapTopup(with: 1_000_000)
        
        // then
        XCTAssertEqual(self.presenter.startLoadingCallCount, 1)
        XCTAssertEqual(self.presenter.stopLoadingCallCount, 1)
        XCTAssertEqual(self.repository.topupCallCount, 1)
        XCTAssertEqual(self.repository.paymentMethodID, "id_0")
        XCTAssertEqual(self.repository.topupAmount, 1_000_000)
        XCTAssertEqual(self.listener.enterAmountDidFinisheTopupCallCount, 1)
    }
    
    func testTopupWithFailure() {
        // given
        let paymentMethod = PaymentMethod(
            id: "id_0",
            name: "name_0",
            digits: "9999",
            color: "#13ABE8FF",
            isPrimary: false
        )
        self.dependency.selectedPaymentMethodSubject.send(paymentMethod)
        self.repository.shouldTopupSucceed = false
        
        // when
        self.sut.didTapTopup(with: 1_000_000)
        
        // then
        XCTAssertEqual(self.presenter.startLoadingCallCount, 1)
        XCTAssertEqual(self.presenter.stopLoadingCallCount, 1)
        XCTAssertEqual(self.repository.topupCallCount, 1)
        XCTAssertEqual(self.repository.paymentMethodID, "id_0")
        XCTAssertEqual(self.repository.topupAmount, 1_000_000)
        XCTAssertEqual(self.listener.enterAmountDidFinisheTopupCallCount, 0)
    }
    
    func testDidTapClose() {
        // given
        
        // when
        self.sut.didTapClose()
        
        // then
        XCTAssertEqual(self.listener.enterAmountDidTapCloseCallCount, 1)
    }
    
    func testDidTapPaymentMethod() {
        // given
        
        // when
        self.sut.didTapPaymentMethod()
        
        // then
        XCTAssertEqual(self.listener.enterAmountDidTapPaymentMethodCallCount, 1)
    }
}
