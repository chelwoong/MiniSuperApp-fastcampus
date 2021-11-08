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
    func attachCardOnFile(paymentMethods: [PaymentMethod])
    func detachCardOnFile()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: TopupInteractorDependency
    
    private var paymentMethods: [PaymentMethod] {
        return self.dependency.cardOnFileRepository.cardOnFile.value
    }
    
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
        
        if let card = self.dependency.cardOnFileRepository.cardOnFile.value.first {
            self.dependency.paymentMethodStream.send(card)
            self.router?.attachEnterAmount()
        } else {
            self.router?.attachAddPaymentMethod()
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
        self.router?.detachEnterAmount()
        self.listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        self.router?.attachCardOnFile(paymentMethods: self.paymentMethods)
    }
    
    func cardOnFileDidTapClose() {
        self.router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        // attach add card
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            self.dependency.paymentMethodStream.send(selected)
        }
        self.router?.detachCardOnFile()
    }
}
