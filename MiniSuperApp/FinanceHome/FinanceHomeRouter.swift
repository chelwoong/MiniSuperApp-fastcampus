import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener, TopupListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
    
    private let superPayDashboardBuildable : SuperPayDashboardBuildable
    private var superPayRouting: Routing?

    private let cardOnFileDashboardBuildable : CardOnFileDashboardBuildable
    private var cardOnFileDashboardRouting: Routing?
    
    private let addPaymentMethodBuildable : AddPaymentMethodBuildable
    private var addPaymentMethodRouting: Routing?
    
    private let topupBuildable : TopupBuildable
    private var topupRouting: Routing?
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable,
        topupBuildable: TopupBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
        self.topupBuildable = topupBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachSuperPayDashboard() {
        guard self.superPayRouting == nil else { return }
        
        let router = self.superPayDashboardBuildable.build(withListener: self.interactor)
        let dashboard = router.viewControllable
        self.viewController.addDashboard(dashboard)
        self.superPayRouting = router
        self.attachChild(router)
    }
    
    func attachCardOnFileDashboard() {
        guard self.cardOnFileDashboardRouting == nil else { return }
        
        let router = self.cardOnFileDashboardBuildable.build(withListener: self.interactor)
        let dashboard = router.viewControllable
        self.viewController.addDashboard(dashboard)
        self.cardOnFileDashboardRouting = router
        self.attachChild(router)
    }
    
    func attachAddPaymentMethod() {
        guard self.addPaymentMethodRouting == nil else { return }
        
        let router = self.addPaymentMethodBuildable.build(withListener: self.interactor)
        let navigation = NavigationControllerable(root: router.viewControllable)
        navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
        self.viewControllable.present(navigation, animated: true, completion: nil)
        self.addPaymentMethodRouting = router
        self.attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        guard let router = addPaymentMethodRouting else { return }
        
        self.viewControllable.dismiss(completion: nil)
        
        self.detachChild(router)
        self.addPaymentMethodRouting = nil
    }
    
    func attachTopup() {
        if topupRouting != nil {
            return
        }
        
        let router = self.topupBuildable.build(withListener: self.interactor)
        self.topupRouting = router
        attachChild(router)
    }
    
    func detachTopup() {
        guard let router = self.topupRouting else { return }
        
        detachChild(router)
        self.topupRouting = nil
    }
}
