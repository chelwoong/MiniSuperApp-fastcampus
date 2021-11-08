//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener {
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
    
    init(
        interactor: TopupInteractable,
        viewController: ViewControllable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable
    ) {
        self.viewController = viewController
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        if viewController.uiviewController.presentationController != nil, navigationControllerable != nil {
            self.navigationControllerable?.dismiss(completion: nil)
        }
    }
    
    func attachAddPaymentMethod() {
        if self.addPaymentMethodRouting != nil {
            return
        }
        
        let router = addPaymentMethodBuildable.build(withListener: self.interactor)
        self.presentInsideNavigation(router.viewControllable)
        self.attachChild(router)
        self.addPaymentMethodRouting = router
    }
    
    func detachAddPaymentMethod() {
        guard let router = self.addPaymentMethodRouting else { return }
        
        self.dismissPresentedNavigation(completion: nil)
        detachChild(router)
        addPaymentMethodRouting = nil
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

    // MARK: - Private

    private let viewController: ViewControllable
}
