//
//  File.swift
//  
//
//  Created by woongs on 2021/12/02.
//

import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport
import CombineSchedulers
@testable import TopupImp
import RIBsTestSupport

final class EnterAmountPresentableMock: EnterAmountPresentable {
    
    var listener: EnterAmountPresentableListener?
    
    var updateSelectedPaymentMethodCallCount = 0
    var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel?
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
        self.updateSelectedPaymentMethodCallCount += 1
        self.updateSelectedPaymentMethodViewModel = viewModel
    }
    
    var startLoadingCallCount = 0
    func startLoading() {
        self.startLoadingCallCount += 1
    }
    
    var stopLoadingCallCount = 0
    func stopLoading() {
        self.stopLoadingCallCount += 1
    }
    
    init() {
        
    }
}

final class EnterAmountDependencyMock: EnterAmountInteractorDependency {
    
    var mainQueue: AnySchedulerOf<DispatchQueue> { .immediate }
    
    var selectedPaymentMethodSubject = CurrentValuePublisher<PaymentMethod>(
        PaymentMethod(
            id: "",
            name: "",
            digits: "",
            color: "",
            isPrimary: false
        )
    )
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { self.selectedPaymentMethodSubject }
    var superPayRepository: SuperPayRepository = SuperPayRepositoryMock()
}

final class EnterAmountListenerMock: EnterAmountListener {
    
    var enterAmountDidTapCloseCallCount = 0
    func enterAmountDidTapClose() {
        self.enterAmountDidTapCloseCallCount += 1
    }
    
    var enterAmountDidTapPaymentMethodCallCount = 0
    func enterAmountDidTapPaymentMethod() {
        self.enterAmountDidTapPaymentMethodCallCount += 1
    }
    
    var enterAmountDidFinisheTopupCallCount = 0
    func enterAmountDidFinishTopup() {
        self.enterAmountDidFinisheTopupCallCount += 1
    }
}

final class EnterAmountBuildableMock: EnterAmountBuildable {
    
    var buildHandler: ((_ listener: EnterAmountListener) -> EnterAmountRouting)?
    
    var buildCallCount = 0
    func build(withListener listener: EnterAmountListener) -> EnterAmountRouting {
        self.buildCallCount += 1
        
        if let buildHandler = buildHandler {
            return buildHandler(listener)
        }
        
        fatalError()
    }
}

final class EnterAmountRoutingMock: ViewableRoutingMock, EnterAmountRouting {
    
}
