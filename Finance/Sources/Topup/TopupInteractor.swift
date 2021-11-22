//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import ModernRIBs
import RIBsUtil
import FinanceEntity
import FinanceRepository
import CombineUtil
import AddPaymentMethod
import SuperUI

protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType)
    func detachAddPaymentMethod()
    func attachEnterAmount()
    func detachEnterAmount()
    func attachCardOnFile(paymentMethods: [PaymentMethod])
    func detachCardOnFile()
    func popToRoot()
}

public protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private var isEnterAmountRoot: Bool = false
    
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
            self.isEnterAmountRoot = true
            self.dependency.paymentMethodStream.send(card)
            self.router?.attachEnterAmount()
        } else {
            self.isEnterAmountRoot = false
            self.router?.attachAddPaymentMethod(closeButtonType: .close)
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
        if isEnterAmountRoot == false {
            self.listener?.topupDidClose()
        }
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
        self.dependency.paymentMethodStream.send(paymentMethod)
        
        if isEnterAmountRoot {
            self.router?.popToRoot()
        } else {
            self.isEnterAmountRoot = true
            self.router?.attachEnterAmount()
        }
    }
    
    func enterAmountDidTapClose() {
        self.router?.detachEnterAmount()
        self.listener?.topupDidClose()
    }
    
    func enterAmountDidTapPaymentMethod() {
        self.router?.attachCardOnFile(paymentMethods: self.paymentMethods)
    }
    
    func enterAmountDidFinisheTopup() {
        self.listener?.topupDidFinish()
    }
    
    func cardOnFileDidTapClose() {
        self.router?.detachCardOnFile()
    }
    
    func cardOnFileDidTapAddCard() {
        self.router?.attachAddPaymentMethod(closeButtonType: .back)
    }
    
    func cardOnFileDidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            self.dependency.paymentMethodStream.send(selected)
        }
        self.router?.detachCardOnFile()
    }
}
