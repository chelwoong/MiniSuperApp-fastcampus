//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    func didTapAddPaymentMethod()
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {

    weak var listener: CardOnFileDashboardPresentableListener?
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "카드 및 계좌"
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(seeAllButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private let cardOnFileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var addMethodButton: AddPaymentMethodButton = {
        let button = AddPaymentMethodButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(addMethodButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func update(with viewModels: [PaymentMethodViewModel]) {
        cardOnFileStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let views = viewModels.map(PaymentMethodView.init)
        
        views.forEach {
            $0.roundCorners()
            self.cardOnFileStackView.addArrangedSubview($0)
        }
        
        self.cardOnFileStackView.addArrangedSubview(self.addMethodButton)
        
        let heightConstraints = views.map { $0.heightAnchor.constraint(equalToConstant: 50) }
        NSLayoutConstraint.activate(heightConstraints)
    }
    
    private func setupViews() {
        self.view.addSubview(self.headerStackView)
        self.view.addSubview(self.cardOnFileStackView)
        
        self.headerStackView.addArrangedSubview(self.titleLabel)
        self.headerStackView.addArrangedSubview(self.seeAllButton)
        
        NSLayoutConstraint.activate([
            self.headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            self.headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            self.cardOnFileStackView.topAnchor.constraint(equalTo: self.headerStackView.bottomAnchor, constant: 10),
            self.cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            self.addMethodButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func seeAllButtonDidTap(_ sender: UIButton) {
        
    }
    
    @objc
    func addMethodButtonDidTap(_ sender: UIButton) {
        self.listener?.didTapAddPaymentMethod()
    }
}
