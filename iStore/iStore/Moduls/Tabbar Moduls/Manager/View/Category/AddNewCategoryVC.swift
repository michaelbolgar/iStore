import UIKit

final class AddNewCategoryVC: UIViewController {
    var product: SingleProduct?
    
    // MARK: - UI Elements
    
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
    
    private var nameTextView = UITextView.makeTextView(height: 52, scroll: true)
    private var priceTextView = UITextView.makeTextView(height: 40, scroll: false)
   
    private var categoryTextField = UITextField.makeTextField(placeholder: "",
                                                              backgroundColor: .violet,
                                                              textColor: .customDarkGray,
                                                              font: .InterRegular(ofSize: 16),
                                                              height: 40,
                                                              showHideButton: false)
    
    private let descriptionTextView = UITextView.makeTextView(height: 125, scroll: true)
    private var imagesTextView = UITextView.makeTextView(height: 52, scroll: true)
    
    
    private lazy var categoryPicker: UIPickerView = {
        let element = UIPickerView()
        element.backgroundColor = .lightViolet
        return element
    }()
    
    private var categories = ["", "Phone", "Monitor", "Mouse", "Earphone"]
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupUIElements()
        priceTextView.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTextField.delegate = self
    }
    
    //MARK: Private Methods
    private func setupViews() {
        
        view.backgroundColor = .white
        
        categoryTextField.layer.borderWidth = 1.0
        categoryTextField.layer.borderColor = UIColor.customLightGray.cgColor
        
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customDarkGray, NSAttributedString.Key.font: UIFont.InterBold(ofSize: 18)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save", style: .plain, target: self, action: #selector(saveChangeButtonTapped))
        
        navigationItem.leftBarButtonItem?.tintColor = .customDarkGray
        navigationController?.navigationBar.tintColor = UIColor.black
     
        [nameLabel, nameTextView, priceLabel, priceTextView, categoryLabel, categoryTextField, descriptionLabel, descriptionTextView, imagesLabel, imagesTextView].forEach { view.addSubview($0) }
    }
    
    private func setupUIElements() {
        nameTextView.text = product?.title
        if let price = product?.price {
            priceTextView.text = "\(price)"
        } else {
            priceTextView.text = ""
        }

        if let categoryName = product?.category.name {
            categories.append(categoryName)
        }
        categoryTextField.text = categories.last
        descriptionTextView.text = product?.description
        imagesTextView.text = product?.images.first!
    }
    
    
    
    @objc private func openCategoryPicker() {
        categoryTextField.inputView = categoryPicker
        categoryTextField.reloadInputViews()
    }
    
    @objc private func saveChangeButtonTapped() {
        guard let productID = product?.id else { return }

        guard let newTitle = nameTextView.text, !newTitle.isEmpty else { return }

        guard let newPriceString = priceTextView.text,
              let newPrice = Int(newPriceString) else { return }

        let newImages = imagesTextView.text.components(separatedBy: ",")

       NetworkingManager.shared.updateProduct(id: productID, newTitle: newTitle, newPrice: newPrice, newDescription: "", newImages: newImages) { result in
            switch result {
            case .success:
                // Handle successful product update
                print("Product updated successfully")
            case .failure(let error):
                // Handle error
                print("Failed to update product:", error)
            }
        }
    }
}

// MARK: - Setup Constraints
private extension AddNewCategoryVC {
    
    func setupConstraints() {
        // Определение константы для удобства
        
        
        NSLayoutConstraint.activate([
            
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

//guard let newName = nameTextView.text,
//      let newImage = imagesTextView.text,
//      let productId = product?.id else {
////              let newPrice = Int(priceTextView.text ?? ""),
////              let newCategoryName = categoryTextField.text,
////              let newDescription = descriptionTextView.text,
//    return
//}
//
//let updatedProduct = UpdatedProduct(name: newName,
//                                      image: newImage)
//print("Инициализация обновленного продукта:", updatedProduct)
//
//NetworkingManager.shared.updateProduct(withId: productId, newData: updatedProduct) { [weak self] result in
//        switch result {
//        case .success(let updatedProduct):
//            
//            // Обновление прошло успешно, обновите интерфейс или выполните другие действия по вашему усмотрению
//            print("Продукт обновлен:", updatedProduct)
//        case .failure(let error):
//            // Обработка ошибки при обновлении продукта
//            print("Ошибка обновления:", error)
//        }
//}
