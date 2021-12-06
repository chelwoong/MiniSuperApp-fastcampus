//
//  File.swift
//  
//
//  Created by woongs on 2021/12/02.
//

import Foundation
import AddPaymentMethod
import ModernRIBs
import RIBsUtil
import RIBsTestSupport

public final class AddPaymentMethodBuildableMock: AddPaymentMethodBuildable {
    
    public var buildCallCount = 0
    public var closeButtonType: DismissButtonType?
    public func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting {
        self.buildCallCount += 1
        self.closeButtonType = closeButtonType
        
        return ViewableRoutingMock(
            interactable: Interactor(),
            viewControllable: ViewControllableMock()
        )
    }
    
    public init() {
        
    }
}
