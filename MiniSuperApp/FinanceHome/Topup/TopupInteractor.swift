//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod()
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmount()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: TopupInteractorDependency
    
    init(
        dependency: TopupInteractorDependency
    ) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        if dependency.cardOnFileRepository.cardOnFile.value.isEmpty {
            // 카드 추가 화면
            self.router?.attachAddPaymentMethod()
        } else {
            // 금액 입력 화면
            self.router?.attachEnterAmount()
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
    }
    
    func presentationControllerDidDismiss() {
        self.listener?.topupDidClose()
    }
    
    func addPaymentMethodDidTapClose() {
        self.router?.detachAddPaymentMethod()
        self.listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        
    }
    
    func enterAmountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
}
