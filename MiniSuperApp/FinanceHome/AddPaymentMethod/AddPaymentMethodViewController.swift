import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
    func didTapClose()
    func didTapConfirm(with number: String, cvc: String, expiry: String)
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {

    weak var listener: AddPaymentMethodPresentableListener?
    
    private let cardNumberTextField: UITextField = {
        let textField = makeTextField()
        textField.placeholder = "카드 번호"
        return textField
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        return stackView
    }()
    
    private let securityTextField: UITextField = {
        let textField = makeTextField()
        textField.placeholder = "CVC"
        return textField
    }()
    
    private let expirationTextField: UITextField = {
        let textField = makeTextField()
        textField.placeholder = "유효기간"
        return textField
    }()
    
    private let addCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.backgroundColor = .primaryRed
        button.setTitle("추가하기", for: .normal)
        button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
        return button
    }()
    
    private static func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupViews()
    }
    
    private func setupViews() {
        self.title = "카드 추가"
        
        self.setupNavigationItem(with: .close, target: self, action: #selector(self.didTapClose))
        
        self.view.backgroundColor = .backgroundColor
        self.view.addSubview(self.cardNumberTextField)
        self.view.addSubview(self.stackView)
        self.view.addSubview(self.addCardButton)
        
        self.stackView.addArrangedSubview(self.securityTextField)
        self.stackView.addArrangedSubview(self.expirationTextField)
        
        NSLayoutConstraint.activate([
            self.cardNumberTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.cardNumberTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.cardNumberTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            self.cardNumberTextField.bottomAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -20),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            self.stackView.bottomAnchor.constraint(equalTo: self.addCardButton.topAnchor, constant: -20),
            self.addCardButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            self.addCardButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            
            self.cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
            self.securityTextField.heightAnchor.constraint(equalToConstant: 60),
            self.expirationTextField.heightAnchor.constraint(equalToConstant: 60),
            self.addCardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc
    private func didTapAddCard(_ sender: UIButton) {
        if let number = self.cardNumberTextField.text,
           let cvc = self.securityTextField.text,
           let expiry = self.expirationTextField.text {
            self.listener?.didTapConfirm(with: number, cvc: cvc, expiry: expiry)
        }
    }
    
    @objc
    private func didTapClose() {
        self.listener?.didTapClose()
    }
}
