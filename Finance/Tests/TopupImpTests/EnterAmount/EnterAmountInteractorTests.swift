//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/12/02.
//

@testable import TopupImp
import XCTest

final class EnterAmountInteractorTests: XCTestCase {

    // system under test
    private var sut: EnterAmountInteractor!
    private var presenter: EnterAmountPresentableMock!
    private var dependency: EnterAmountDependencyMock!
    private var listener: EnterAmountListenerMock!

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

    func test_exampleObservable_callsRouterOrListener_exampleProtocol() {
        // This is an example of an interactor test case.
        // Test your interactor binds observables and sends messages to router or listener.
    }
}
