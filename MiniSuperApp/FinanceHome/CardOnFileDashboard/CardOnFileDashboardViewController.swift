//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/01.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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
    
    private func setupViews() {
        self.view.addSubview(self.headerStackView)
        self.view.addSubview(self.cardOnFileStackView)
        
        self.headerStackView.addArrangedSubview(self.titleLabel)
        self.headerStackView.addArrangedSubview(self.seeAllButton)
        
        
        self.cardOnFileStackView.addArrangedSubview(self.addMethodButton)
        
        NSLayoutConstraint.activate([
            self.headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            self.headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            self.cardOnFileStackView.topAnchor.constraint(equalTo: self.headerStackView.bottomAnchor, constant: 10),
            self.cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addMethodButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func seeAllButtonDidTap(_ sender: UIButton) {
        
    }
    
    @objc
    func addMethodButtonDidTap(_ sender: UIButton) {
        
    }
}
