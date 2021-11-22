import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import Topup

public protocol FinanceHomeDependency: Dependency {
    var cardOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
    var topupBuildable: TopupBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
    
    var cardOnFileRepository: CardOnFileRepository { self.dependency.cardOnFileRepository }
    var superPayRepository: SuperPayRepository { self.dependency.superPayRepository }
    var balance: ReadOnlyCurrentValuePublisher<Double> { self.superPayRepository.balance }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { self.dependency.addPaymentMethodBuildable }
    var topupBuildable: TopupBuildable { self.dependency.topupBuildable }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        let viewController = FinanceHomeViewController()
        let component = FinanceHomeComponent(dependency: self.dependency)
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        
        return FinanceHomeRouter(interactor: interactor,
                                 viewController: viewController,
                                 superPayDashboardBuildable: superPayDashboardBuilder,
                                 cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
                                 addPaymentMethodBuildable: component.addPaymentMethodBuildable,
                                 topupBuildable: component.topupBuildable)
    }
}
