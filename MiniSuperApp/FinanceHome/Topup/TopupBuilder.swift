//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import ModernRIBs

protocol TopupDependency: Dependency {
    var topupBaseViewController: ViewControllable { get }
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {
    
    var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { self.paymentMethodStream }
    var cardOnFileRepository: CardOnFileRepository { self.dependency.cardOnFileRepository }
    fileprivate var topupBaseViewController: ViewControllable { self.dependency.topupBaseViewController }
    
    let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    
    init(
        dependency: TopupDependency,
        paymentMethodStream: CurrentValuePublisher<PaymentMethod>
    ) {
        self.paymentMethodStream = paymentMethodStream
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

    override init(dependency: TopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TopupListener) -> TopupRouting {
        let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))
        
        let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
        let interactor = TopupInteractor(dependency: component)
        interactor.listener = listener
        
        let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
        let enterAmountBuilder = EnterAmountBuilder(dependency: component)
        let cardOnFileBuilder = CardOnFileBuilder(dependency: component)
        return TopupRouter(interactor: interactor,
                           viewController: component.topupBaseViewController,
                           addPaymentMethodBuildable: addPaymentMethodBuilder,
                           enterAmountBuildable: enterAmountBuilder,
                           cardOnFileBuildable: cardOnFileBuilder)
    }
}
