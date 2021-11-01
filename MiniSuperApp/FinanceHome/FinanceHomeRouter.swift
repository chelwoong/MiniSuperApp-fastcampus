import ModernRIBs

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener {
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
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuildable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuildable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
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
}
