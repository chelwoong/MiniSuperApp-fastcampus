//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import ModernRIBs
import AddPaymentMethod
import SuperUI
import RIBsUtil
import FinanceEntity

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
    
    private var navigationControllerable: NavigationControllerable?

    private let addPaymentMethodBuildable: AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let enterAmountBuildable: EnterAmountBuildable
    private var enterAmountRouting: Routing?
    
    private let cardOnFileBuildable: CardOnFileBuildable
    private var cardOnFileRouting: Routing?
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        enterAmountBuildable: EnterAmountBuildable,
        cardOnFileBuildable: CardOnFileBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.enterAmountBuildable = enterAmountBuildable
        self.cardOnFileBuildable = cardOnFileBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentationController != nil, navigationControllerable != nil {
            self.navigationControllerable?.dismiss(completion: nil)
        }
    }
    
    func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
        if self.addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: self.interactor, closeButtonType: closeButtonType)
        if let navigationControllerable = self.navigationControllerable {
            navigationControllerable.pushViewController(router.viewControllable, animated: true)
        } else {
            self.presentInsideNavigation(router.viewControllable)
        }
        
        self.attachChild(router)
        self.addPaymentMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = self.addPaymentMethodRouting else { return }
        
        self.navigationControllerable?.popViewController(animated: true)
        self.detachChild(router)
        self.addPaymentMethodRouting = nil
    }
    
    func attachEnterAmount() {
        if self.enterAmountRouting != nil {
            return
        }
        
        let router = self.enterAmountBuildable.build(withListener: self.interactor)
        
        if let navigation = self.navigationControllerable {
            navigation.setViewControllers([router.viewControllable])
            self.resetChildRouting()
        } else {
            self.presentInsideNavigation(router.viewControllable)
        }
        
        self.attachChild(router)
        self.enterAmountRouting = router
    }
    
    func detachEnterAmount() {
        guard let router = self.enterAmountRouting else { return }
        
        self.dismissPresentedNavigation(completion: nil)
        self.detachChild(router)
        self.enterAmountRouting = nil
    }
    
    func attachCardOnFile(paymentMethods: [PaymentMethod]) {
        if self.cardOnFileRouting != nil {
            return
        }
        
        let router = self.cardOnFileBuildable.build(withListener: self.interactor, paymentMethods: paymentMethods)
        navigationControllerable?.pushViewController(router.viewControllable, animated: true)
        self.cardOnFileRouting = router
        self.attachChild(router)
    }
    
    func detachCardOnFile() {
        guard let router = self.cardOnFileRouting else { return }
        
        self.navigationControllerable?.popViewController(animated: true)
        self.detachChild(router)
        self.cardOnFileRouting = nil
    }
    
    func popToRoot() {
        self.navigationControllerable?.popToRoot(animated: true)
        self.resetChildRouting()
    }
    
    private func presentInsideNavigation(_ viewControllable: ViewControllable) {
        let navigation = NavigationControllerable(root: viewControllable)
        navigation.navigationController.presentationController?.delegate = self.interactor.presentationDelegateProxy
        self.navigationControllerable = navigation
        self.viewController.present(navigation, animated: true, completion: nil)
    }
    
    private func dismissPresentedNavigation(completion: (() -> Void)?) {
        if self.navigationControllerable == nil {
            return
        }
        
        self.viewController.dismiss(completion: completion)
        self.navigationControllerable = nil
    }
    
    private func resetChildRouting() {
        if let cardOnFileRouting = self.cardOnFileRouting {
            self.detachChild(cardOnFileRouting)
            self.cardOnFileRouting = nil
        }
        
        if let addPaymentMethodRouting = self.addPaymentMethodRouting {
            self.detachChild(addPaymentMethodRouting)
            self.addPaymentMethodRouting = nil
        }
    }

    // MARK: - Private

    private let viewController: ViewControllable
}
