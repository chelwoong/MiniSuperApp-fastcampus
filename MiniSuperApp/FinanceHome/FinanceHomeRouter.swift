import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener, AddPaymentMethodListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
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
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
        addPaymentMethodBuildable: AddPaymentMethodBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
        self.addPaymentMethodBuildable = addPaymentMethodBuildable
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
        self.viewControllable.present(navigation, animated: true, completion: nil)
        self.addPaymentMethodRouting = router
        self.attachChild(router)
    }
    
    func detachAddPaymentMethod() {
        
    }
}
