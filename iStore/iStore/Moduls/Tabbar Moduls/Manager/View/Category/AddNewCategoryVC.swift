import UIKit

final class AddNewCategoryVC: UIViewController {
    
    // MARK: - UI Elements
    private let addNewProductTitle = UILabel.makeLabel(text: "Add new product",
                                                 font: .InterBold(ofSize: 24),
                                                 textColor: .customDarkGray,
                                                 numberOfLines: nil,
                                                 alignment: .center)
   
    private let nameLabel = UILabel.makeLabel(text: "Title",
                                  font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                  textColor: .customDarkGray,
                                  numberOfLines: 1,
                                  alignment: .left)
    
    private let priceLabel = UILabel.makeLabel(text: "Price",
                                  font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                  textColor: .customDarkGray,
                                  numberOfLines: 1,
                                  alignment: .left)
    
    private let categoryLabel = UILabel.makeLabel(text: "Category",
                                  font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                  textColor: .customDarkGray,
                                  numberOfLines: 1,
                                  alignment: .left)
    
    private let descriptionLabel = UILabel.makeLabel(text: "Description",
                                  font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                  textColor: .customDarkGray,
                                  numberOfLines: 1,
                                  alignment: .left)
    
    private let imagesLabel = UILabel.makeLabel(text: "Images",
                                  font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                  textColor: .customDarkGray,
                                  numberOfLines: 1,
                                  alignment: .left)
    
    private var nameTextView = UITextView.makeTextView(height: 40, scroll: false)
    private var priceTextView = UITextView.makeTextView(height: 40, scroll: false)
   
    private var categoryTextField = UITextField.makeTextField(placeholder: "",
                                                              backgroundColor: .violet,
                                                              textColor: .customDarkGray,
                                                              font: .InterRegular(ofSize: 16),
                                                              height: 40,
                                                              showHideButton: false)
    
    private let descriptionTextView = UITextView.makeTextView(height: 125, scroll: true)
    private var imagesTextView = UITextView.makeTextView(height: 40, scroll: true)
    
    
    private lazy var categoryPicker: UIPickerView = {
        let element = UIPickerView()
        element.backgroundColor = .lightViolet
        return element
    }()
    private var categories = ["Phone", "Monitor", "Mouse", "Earphone",]
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        priceTextView.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.delegate = self
//        categoryTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCategoryPicker)))
    }
    
    //MARK: Private Methods
    private func setupViews() {
        
        view.backgroundColor = .white
        
        categoryTextField.layer.borderWidth = 1.0
        categoryTextField.layer.borderColor = UIColor.customLightGray.cgColor
     
        [addNewProductTitle, nameLabel, nameTextView, priceLabel, priceTextView, categoryLabel, categoryTextField, descriptionLabel, descriptionTextView, imagesLabel, imagesTextView].forEach { view.addSubview($0) }
    }
@objc private func openCategoryPicker() {
        categoryTextField.inputView = categoryPicker
        categoryTextField.reloadInputViews()
    }

}

// MARK: - Setup Constraints
private extension AddNewCategoryVC {
    
    func setupConstraints() {
        // Определение константы для удобства
        
        
        NSLayoutConstraint.activate([
            
            addNewProductTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addNewProductTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),

            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.widthAnchor.constraint(equalToConstant: 100),
            priceLabel.heightAnchor.constraint(equalToConstant: 40),
            
            categoryLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 30),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryLabel.widthAnchor.constraint(equalToConstant: 100),
            categoryLabel.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 100),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            imagesLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 115),
            imagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imagesLabel.widthAnchor.constraint(equalToConstant: 100),
            imagesLabel.heightAnchor.constraint(equalToConstant: 40),
            
            nameTextView.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priceTextView.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            priceTextView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            priceTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            categoryTextField.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
            categoryTextField.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            imagesTextView.topAnchor.constraint(equalTo: imagesLabel.topAnchor),
            imagesTextView.leadingAnchor.constraint(equalTo: imagesLabel.trailingAnchor),
            imagesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
}

extension UITextView {
    static func makeTextView(height: Double, scroll: Bool) -> UITextView {
            let element = UITextView()
            element.backgroundColor = .lightViolet
            element.font = .InterRegular(ofSize: 16)
            element.textColor = .customDarkGray
            element.isEditable = true
            element.isScrollEnabled = scroll
            element.isSelectable = true
            element.textAlignment = .left
            element.layer.cornerRadius = 8
            element.layer.borderWidth = 1.0
            element.layer.borderColor = UIColor.customLightGray.cgColor
            element.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            element.heightAnchor.constraint(equalToConstant: height)
        ])
            return element
    }
}

extension AddNewCategoryVC: UITextViewDelegate {
    //чтобы в прайс можно было ввести только цифры
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Проверяем, является ли вводимый текст числом
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: text)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}

extension AddNewCategoryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("numberOfComponents")
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("categories.count")
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("categories[row]")
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
        print("categoryTextView.text = categories[row]")
    }
}

extension AddNewCategoryVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryTextField {
            textField.inputView = categoryPicker
            textField.reloadInputViews()
        }
    }
}

