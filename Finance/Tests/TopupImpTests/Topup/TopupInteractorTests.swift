//
//  TopupInteractorInteractorTests.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/12/02.
//

@testable import TopupImp
import XCTest
import TopupTestSupport
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport

final class TopupInteractorTests: XCTestCase {

    private var sut: TopupInteractor!
    private var dependency: TopupDependencyMock!
    private var listener: TopupListenerMock!
    private var router: TopupRoutingMock!
    
    private var cardOnFileRepository: CardOnFileRepositoryMock {
        self.dependency.cardOnFileRepository as! CardOnFileRepositoryMock
    }
    
    override func setUp() {
        super.setUp()
        
        self.dependency = TopupDependencyMock()
        self.listener = TopupListenerMock()
        
        let interactor = TopupInteractor(dependency: self.dependency)
        self.router = TopupRoutingMock(interactable: interactor)
        
        interactor.listener = self.listener
        interactor.router = self.router
        self.sut = interactor
    }

    // MARK: - Tests

    func testActivate() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false)
        ]
        self.cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        self.sut.activate()
        
        // then
        XCTAssertEqual(self.router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(self.dependency.paymentMethodStream.value.name, "Zero")
    }
    
    func testActivateWithoutCard() {
        // given
        self.cardOnFileRepository.cardOnFileSubject.send([])
        
        // when
        self.sut.activate()
        
        // then
        XCTAssertEqual(self.router.attachAddPaymentMethodCallCount, 1)
        XCTAssertEqual(self.router.attachAddPaymentMethodCloseButtonType, .close)
    }
    
    func testDidAddCardWithCard() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false)
        ]
        self.cardOnFileRepository.cardOnFileSubject.send(cards)
        
        let newCard = PaymentMethod(
            id: "new_card_id",
            name: "New Card",
            digits: "0000",
            color: "",
            isPrimary: false
        )
        
        // when
        self.sut.activate()
        self.sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(self.router.popToRootCallCount, 1)
        XCTAssertEqual(self.dependency.paymentMethodStream.value.id, "new_card_id")
    }
    
    func testDidAddCardWithoutCard() {
        // given
        self.cardOnFileRepository.cardOnFileSubject.send([])
        
        let newCard = PaymentMethod(
            id: "new_card_id",
            name: "New Card",
            digits: "0000",
            color: "",
            isPrimary: false
        )
        
        // when
        self.sut.activate()
        self.sut.addPaymentMethodDidAddCard(paymentMethod: newCard)
        
        // then
        XCTAssertEqual(self.router.attachEnterAmountCallCount, 1)
        XCTAssertEqual(self.dependency.paymentMethodStream.value.id, "new_card_id")
    }
    
    func testAddPaymentMethodDidCloseFromEnterAmount() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false)
        ]
        self.cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        self.sut.activate()
        self.sut.addPaymentMethodDidTapClose()
        
        // then
        XCTAssertEqual(self.router.detachAddPaymentMethodCallCount, 1)
    }
    
    func testAddPaymentMethodDidClose() {
        // given
        self.cardOnFileRepository.cardOnFileSubject.send([])
        
        // when
        self.sut.activate()
        self.sut.addPaymentMethodDidTapClose()
        
        // then
        XCTAssertEqual(self.router.detachAddPaymentMethodCallCount, 1)
        XCTAssertEqual(self.listener.topupDidCloseCallCount, 1)
    }
    
    func testDidSelectCard() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            ),
            PaymentMethod(
                id: "1",
                name: "One",
                digits: "1234",
                color: "",
                isPrimary: false
            )
        ]
        self.cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        self.sut.cardOnFileDidSelect(at: 0)
        
        // then
        XCTAssertEqual(self.dependency.paymentMethodStream.value.id, "0")
        XCTAssertEqual(self.router.detachCardOnFileCallCount, 1)
    }
    
    func testDidSelectCardWithInvalidIndex() {
        // given
        let cards = [
            PaymentMethod(
                id: "0",
                name: "Zero",
                digits: "0123",
                color: "",
                isPrimary: false
            ),
            PaymentMethod(
                id: "1",
                name: "One",
                digits: "1234",
                color: "",
                isPrimary: false
            )
        ]
        self.cardOnFileRepository.cardOnFileSubject.send(cards)
        
        // when
        self.sut.cardOnFileDidSelect(at: 2)
        
        // then
        XCTAssertEqual(self.dependency.paymentMethodStream.value.id, "")
        XCTAssertEqual(self.router.detachCardOnFileCallCount, 1)
    }
}
