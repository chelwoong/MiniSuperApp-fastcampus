//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/10/24.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
    func topupButtonDidTap()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {
    
    weak var listener: SuperPayDashboardPresentableListener?
    
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
        label.text = "슈퍼페이 잔고"
        return label
    }()
    
    private let topupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("충전하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.accessibilityIdentifier = "superpay_dashboard_topup_button"
        button.addTarget(self, action: #selector(topupButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "원"
        label.textColor = .white
        return label
    }()
    
    private let balanceAmountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.accessibilityIdentifier = "superpay_dashboard_balance_label"
        label.textColor = .white
        return label
    }()
    
    private let balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    private func setupViews() {
        self.view.addSubview(self.headerStackView)
        self.view.addSubview(self.cardView)
        
        self.headerStackView.addArrangedSubview(self.titleLabel)
        self.headerStackView.addArrangedSubview(self.topupButton)
        
        self.cardView.addSubview(self.balanceStackView)
        self.balanceStackView.addArrangedSubview(self.balanceAmountLabel)
        self.balanceStackView.addArrangedSubview(self.currencyLabel)
        
        NSLayoutConstraint.activate([
            self.headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            self.headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            self.cardView.topAnchor.constraint(equalTo: self.headerStackView.bottomAnchor, constant: 10),
            self.cardView.leadingAnchor.constraint(equalTo: self.headerStackView.leadingAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.headerStackView.trailingAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            self.cardView.heightAnchor.constraint(equalToConstant: 180),
            
            self.balanceStackView.centerXAnchor.constraint(equalTo: self.cardView.centerXAnchor),
            self.balanceStackView.centerYAnchor.constraint(equalTo: self.cardView.centerYAnchor),
        ])
    }
    
    @objc
    func topupButtonDidTap(_ sender: UIButton) {
        self.listener?.topupButtonDidTap()
    }
    
    // MARK: - SuperPayDashboardPresentable
    
    func updateBalance(_ balance: String) {
        self.balanceAmountLabel.text = balance
    }
}
