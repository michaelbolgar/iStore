// экран для быстрых тестов разных фич, как например запросы по апи. Можно оставлять тут примеры для других участников команды

import UIKit

class ViewController: UIViewController {

    // MARK: UI Elements
    
    let label = UILabel.makeLabel(text: "Hello, world!",
                                  font: UIFont.InterSemiBold(ofSize: 16),
                                  textColor: .black,
                                  numberOfLines: 1,
                                  alignment: nil)

    let button = UIButton.makeButton(text: "Click",
                                          buttonColor: .green,
                                          titleColor: .white,
                                          titleSize: 16,
                                          width: 300,
                                          height: 50)

    let textField = UITextField.makeTextField(placeholder: "Write anything",
                                              backgroundColor: .violet,
                                              textColor: .black,
                                              font: UIFont.systemFont(ofSize: 16),
                                              height: 50,
                                              showHideButton: false)

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(label)
        view.addSubview(button)
        view.addSubview(textField)
//        label.backgroundColor = .red
        setConstraints()
        setButton()
        view.hideKeyboard()
    }

    // MARK: Private Methods

    private func setConstraints() {

        NSLayoutConstraint.activate([

            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            label.widthAnchor.constraint(equalToConstant: 200)

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),

            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -100),
            textField.widthAnchor.constraint(equalToConstant: 300)

        ])

    }

    private func setButton() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    // MARK: Selector Methods

    @objc private func buttonTapped() {
        print ("click")
    }
}
