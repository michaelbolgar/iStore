import UIKit

// Тэги для переключения подчеркивания
struct LayerTags {
    static let blackUnderlineTag = 1
    static let redUnderlineTag = 2
}

class CardView: UIView {
    
    // MARK: UI Elements
    
    var activeTextField: UITextField?
    
    lazy var cardNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "1111 2222 3333 4444"
        textField.tintColor = UIColor.clear
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    lazy var expiryDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/YY"
        textField.tintColor = .clear
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    lazy var cvvTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "CVV"
        textField.tintColor = UIColor.clear
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DevRushLogo")
        imageView.frame = CGRect(x: 20, y: 20, width: 30, height: 30)
        return imageView
    }()
    
    private lazy var bankLabel: UILabel = {
        let label = UILabel()
        label.text = "DYADICHEV BANK"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .customDarkGray
        return label
    }()
    
    // MARK: Picker properties
    
    private let monthYearPicker = UIPickerView()
    private let months = (1...12).map { String(format: "%02d", $0) }
    private let years: [String] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (currentYear...(currentYear + 20)).map { String($0 % 100) }
    }()
    
    private var selectedMonth: String?
    private var selectedYear: String?
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupCardView()
        setupLayouts()
        setupMonthYearPicker()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setupCardView() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.applyShadow()
        
        cardNumberTextField.delegate = self
        cvvTextField.delegate = self
    }
    
    // MARK: Private methods
    
    private func setupLayouts() {
        let subView = [cardNumberTextField, 
                       expiryDateTextField, 
                       cvvTextField, 
                       logoImageView, 
                       bankLabel]
        
        subView.forEach { addSubview($0) }
        subView.forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            cardNumberTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cardNumberTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -120),
            
            expiryDateTextField.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
            expiryDateTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            expiryDateTextField.widthAnchor.constraint(equalToConstant: 80),
            
            cvvTextField.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
            cvvTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            cvvTextField.widthAnchor.constraint(equalToConstant: 40),
            
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            bankLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 10),
            bankLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor)
        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Selector methods
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
}

// MARK: Extension Date UIPicker

extension CardView {
    private func setupMonthYearPicker() {
        monthYearPicker.delegate = self
        monthYearPicker.dataSource = self
        
        expiryDateTextField.inputView = monthYearPicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonAction))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearFieldAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        doneButton.tintColor = .customDarkGray
        clearButton.tintColor = .customDarkGray
        
        toolbar.setItems([clearButton, spaceButton, doneButton], animated: false)
        expiryDateTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        if let month = selectedMonth, let year = selectedYear {
            expiryDateTextField.text = "\(month)/\(year)"
        }
        expiryDateTextField.resignFirstResponder()
        expiryDateTextField.removeUnderline(withTag: LayerTags.redUnderlineTag)
    }
    
    @objc func clearFieldAction() {
        expiryDateTextField.text = ""
        expiryDateTextField.resignFirstResponder()
        expiryDateTextField.removeUnderline(withTag: LayerTags.redUnderlineTag)
    }
}

// MARK: Extension gradient and shadow

extension CardView {
    private func applyShadow() {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowRadius = 4.0
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.frame = self.bounds
        self.layer.addSublayer(shadowLayer)
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
            UIColor(white: 0.6, alpha: 1.0).cgColor,
            UIColor(white: 0.9, alpha: 1.0).cgColor 
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // Накладываем градиент
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.first?.frame = self.bounds
    }
}

// MARK: Extension UITextFieldDelegate

extension CardView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        textField.addBlackUnderline()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.removeUnderline(withTag: LayerTags.blackUnderlineTag)
        textField.removeUnderline(withTag: LayerTags.redUnderlineTag)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text, let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            
            if !updatedText.isEmpty {
                textField.removeUnderline(withTag: LayerTags.redUnderlineTag)
            }
        }
        return true
    }
}

// MARK: Extension UIPickerViewDelegate, UIPickerViewDataSource

extension CardView:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? months[row] : years[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMonth = months[row]
        } else {
            selectedYear = years[row]
        }
    }
}

// MARK: Extension Textfield

extension UITextField {
    func addBlackUnderline() {
        removeUnderline(withTag: LayerTags.blackUnderlineTag)
        let border = CALayer()
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 2)
        border.borderWidth = 2
        border.setValue(LayerTags.blackUnderlineTag, forKey: "tag")
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func addRedUnderline() {
        removeUnderline(withTag: LayerTags.redUnderlineTag)
        let border = CALayer()
        border.borderColor = UIColor.red.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        border.borderWidth = 1
        border.setValue(LayerTags.redUnderlineTag, forKey: "tag")
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func removeUnderline(withTag tag: Int) {
        self.layer.sublayers?.first(where: { $0.value(forKey: "tag") as? Int == tag })?.removeFromSuperlayer()
    }
}


