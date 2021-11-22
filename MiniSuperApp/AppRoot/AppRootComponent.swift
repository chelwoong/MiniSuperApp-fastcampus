//
//  File.swift
//  
//
//  Created by woongs on 2021/11/22.
//

import Foundation
import AppHome
import ModernRIBs
import FinanceHome
import ProfileHome
import FinanceRepository
import TransportHome
import TransportHomeImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency {
    
    var cardOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    init(
        dependency: AppRootDependency,
        cardOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository
    ) {
        self.cardOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        super.init(dependency: dependency)
    }
}
