//
//  TopupInteractorRouterTests.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/12/02.
//

@testable import TopupImp
import XCTest
import RIBsTestSupport
import AddPaymentMethodTestSupport
import ModernRIBs

final class TopupRouterTests: XCTestCase {

    private var sut: TopupRouter!
    private var interactor: TopupInteractableMock!
    private var viewController: ViewControllableMock!
    private var addPaymentMethodBuildable: AddPaymentMethodBuildableMock!
    private var enterAmountBuildable: EnterAmountBuildableMock!
    private var cardOnFileBuildable: CardOnFileBuildableMock!

    override func setUp() {
        super.setUp()
        
        self.interactor = TopupInteractableMock()
        self.viewController = ViewControllableMock()
        self.addPaymentMethodBuildable = AddPaymentMethodBuildableMock()
        self.enterAmountBuildable = EnterAmountBuildableMock()
        self.cardOnFileBuildable = CardOnFileBuildableMock()
        
        self.sut = TopupRouter(
            interactor: self.interactor,
            viewController: self.viewController,
            addPaymentMethodBuildable: self.addPaymentMethodBuildable,
            enterAmountBuildable: self.enterAmountBuildable,
            cardOnFileBuildable: self.cardOnFileBuildable)
    }

    // MARK: - Tests

    func testAttachAddPaymentMethod() {
        // given
        
        // when
        self.sut.attachAddPaymentMethod(closeButtonType: .close)
        
        // then
        XCTAssertEqual(self.addPaymentMethodBuildable.buildCallCount, 1)
        XCTAssertEqual(self.addPaymentMethodBuildable.closeButtonType, .close)
        XCTAssertEqual(self.viewController.presentCallCount, 1)
    }
    
    func testAttachEnterAmount() {
        // given
        let router = EnterAmountRoutingMock(
            interactable: Interactor(),
            viewControllable: ViewControllableMock()
        )
        
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedListener = listener
            return router
        }
        
        // when
        self.sut.attachEnterAmount()
        
        // then
        XCTAssertTrue(assignedListener === interactor)
        XCTAssertEqual(self.enterAmountBuildable.buildCallCount, 1)
    }
    
    func testAttachEnterAmountOnNavigation() {
        // given
        let router = EnterAmountRoutingMock(
            interactable: Interactor(),
            viewControllable: ViewControllableMock()
        )
        
        var assignedListener: EnterAmountListener?
        enterAmountBuildable.buildHandler = { listener in
            assignedListener = listener
            return router
        }
        
        // when
        self.sut.attachAddPaymentMethod(closeButtonType: .close)
        self.sut.attachEnterAmount()
        
        // then
        XCTAssertTrue(assignedListener === interactor)
        XCTAssertEqual(self.enterAmountBuildable.buildCallCount, 1)
        XCTAssertEqual(self.viewController.presentCallCount, 1)
        XCTAssertEqual(self.sut.children.count, 1)
    }
}
