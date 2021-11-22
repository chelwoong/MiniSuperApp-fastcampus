//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import UIKit

final class PaymentMethodView: UIView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.text = "**** 9999"
        return label
    }()
    
    init(viewModel: PaymentMethodViewModel) {
        super.init(frame: .zero)
        
        self.setupViews()
        
        self.nameLabel.text = viewModel.name
        self.subtitleLabel.text = viewModel.digits
        self.backgroundColor = viewModel.color
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .systemIndigo
        self.roundCorners()
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.subtitleLabel)
        
        NSLayoutConstraint.activate([
            self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            self.subtitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
