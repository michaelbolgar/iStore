import UIKit

final class TermsViewController: UIViewController {

    //MARK: - UI Elements
    private let termsConditions = UILabel.makeLabel(text: "Terms & Conditions",
                                                    font: .InterBold(ofSize: 24),
                                                    textColor: .customDarkGray,
                                                    numberOfLines: nil,
                                                    alignment: .center)

    private let textRuleView: UITextView = {
        let element = UITextView()
        element.backgroundColor = .clear
        element.font = .InterRegular(ofSize: 16)
        element.textColor = .customLightGray
        element.isEditable = false
        element.isScrollEnabled = true
        element.isSelectable = false
        element.text = textForRules.termsConditionsText
        element.textAlignment = .left
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
    }

    private func setupViews(){
        view.backgroundColor = .white
        
        [ textRuleView, termsConditions].forEach { view.addSubview($0) }
    }
}

extension TermsViewController {
    private func setupConstrains() {

        NSLayoutConstraint.activate([
            
            textRuleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            textRuleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            textRuleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            textRuleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
            termsConditions.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            termsConditions.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 74),
            termsConditions.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -74),
            termsConditions.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}


