import UIKit

class PaymentVC: UIViewController {
    
    // MARK: Properties
    
    private var numberButtons: [UIButton] = []
    private var cardView = CardView()
    
    // MARK: UI Elements
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Pay", for: .normal)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.InterBold(ofSize: 25)
        return button
    }()
    
    private lazy var shadowView: UIView = {
        let shadow = UIView()
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadow.layer.shadowOpacity = 0.5
        shadow.layer.shadowRadius = 4
        shadow.layer.cornerRadius = 15
        return shadow
    }()
    
    // Затемнение фона с помощью наложения UIView
    lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        return view
    }()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButtons()
        setupTapGesture()
        setupDimmingView()
        setNavigationBar(title: "Finish payment")
    }

    // MARK: Private methods
    
    private func insertNumber(_ number: String, into textField: UITextField) {
        var currentText = textField.text ?? ""
        currentText += number
        let unformattedText = currentText.replacingOccurrences(of: " ", with: "")
        
        if textField == cardView.cardNumberTextField && unformattedText.count > 16 {
            return
        }
        
        var formattedText = ""
        for (index, character) in unformattedText.enumerated() {
            if index != 0 && index % 4 == 0 {
                formattedText += " "
            }
            formattedText += String(character)
        }
        textField.text = formattedText
        
        if textField == cardView.cvvTextField && currentText.count >= 3 {
            textField.text = String(currentText.prefix(3))
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func areFieldsValid() -> Bool {
        let fields = [cardView.cardNumberTextField, cardView.expiryDateTextField, cardView.cvvTextField]
        var isValid = true
        
        for field in fields {
            if let text = field.text, text.isEmpty {
                field.addRedUnderline()
                isValid = false
            }
        }
        return isValid
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please fill in all the fields correctly.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func payButtonTapped() {
        if !areFieldsValid() {
            showAlert()
            return
        }
        
        let successVC = SuccessViewController()
        successVC.modalPresentationStyle = .custom
        successVC.transitioningDelegate = self
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
        }
        present(successVC, animated: true)
    }
}

// MARK: Extension layouts

extension PaymentVC {
    private func setupView() {
        view.backgroundColor = .white
        
        let views = [shadowView, cardView, payButton, dimmingView]
        
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(shadowView)
        view.addSubview(payButton)
        shadowView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            shadowView.heightAnchor.constraint(equalToConstant: 200),
            
            cardView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: Extension for create keyboard

extension PaymentVC {
    private func setupButtons() {
        let buttonTitles = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "?", "0", "⌫"]
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = .InterMedium(ofSize: 30)
            button.tintColor = .customLightGray
            
            if title == "⌫" {
                button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
            } else if !title.isEmpty {
                button.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
            }
            
            // Размещение кнопок на UI
            view.addSubview(button)
            numberButtons.append(button)
            
            let columns = 3
            let horizontalPadding: CGFloat = 10
            let verticalPadding: CGFloat = 20
            let buttonWidth = (view.frame.size.width - CGFloat(columns + 1) * horizontalPadding) / CGFloat(columns)
            let buttonHeight: CGFloat = 50
            let row = index / columns
            let column = index % columns
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonWidth),
                button.heightAnchor.constraint(equalToConstant: buttonHeight),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: CGFloat(column) * (buttonWidth + horizontalPadding) + horizontalPadding),
                button.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: CGFloat(row) * (buttonHeight + verticalPadding) + verticalPadding + 30)
            ])
        }
    }
    
    private func openDevRushWebsite() {
        if let url = URL(string: "https://devrush.eduonline.io") {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: Actions
    
    @objc private func numberPressed(_ sender: UIButton) {
        guard let number = sender.title(for: .normal), let textField = cardView.activeTextField else { return }
        
        switch number {
        case "⌫":
            deletePressed()
        case "?":
            openDevRushWebsite()
        default:
            insertNumber(number, into: textField)
        }
    }
    
    @objc private func deletePressed() {
        guard let textField = cardView.activeTextField, var text = textField.text, !text.isEmpty else { return }
        
        if textField == cardView.cardNumberTextField && text.last == " " {
            text.removeLast()
        }
        text.removeLast()
        textField.text = text
    }
}

extension PaymentVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension PaymentVC {
    private func setupDimmingView() {
        view.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
