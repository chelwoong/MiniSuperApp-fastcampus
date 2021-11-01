//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import UIKit

final class AddPaymentMethodButton: UIControl {
    
    private let plusIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus",
                                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold)))
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
    
    func setupViews() {
        self.addSubview(self.plusIcon)
        
        NSLayoutConstraint.activate([
            plusIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
