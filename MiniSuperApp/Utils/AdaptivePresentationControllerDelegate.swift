//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/08.
//

import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
    func presentationControllerDidDismiss()
}

final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
    
    weak var delegate: AdaptivePresentationControllerDelegate?
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.presentationControllerDidDismiss()
    }
}
