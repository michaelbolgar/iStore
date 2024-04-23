import UIKit

protocol ChangeProfileViewControllerDelegate: AnyObject {
    func didSelectAccountType(_ type: String)
}

final class ChangeProfileViewController: UIViewController {
    weak var delegate: ChangeProfileViewControllerDelegate?
    
    // MARK: - UI Element
    private lazy var containerView: UIView = {
        let element = UIView()
        element.backgroundColor = .white
        element.layer.cornerRadius = 12
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()

    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Select account type"
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
  
    private let userView = UIView.makeGreyButton(textLabel: "User",
                                                textColor: .customDarkGray,
                                                nameMarker: "person.fill",
                                                colorMarker: .deepGreen)
    
    private let managerView = UIView.makeGreyButton(textLabel: "Manager",
                                                     textColor: .customDarkGray,
                                                     nameMarker: "person.badge.key.fill",
                                                     colorMarker: .customYellow)

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: - Private Methods
    private func setupViews() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        
        [blurView, containerView ].forEach { view.addSubview($0) }
        
        [titleLabel, userView, managerView].forEach { containerView.addSubview($0) }
        
        //добавляем рекогнайзер на кнопки(вью)
        userView.isUserInteractionEnabled = true
        managerView.isUserInteractionEnabled = true

        let typeAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(userViewTapped))
        userView.addGestureRecognizer(typeAccountTapGesture)

        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(managerViewTapped))
        managerView.addGestureRecognizer(termsTapGesture)
    }
    
    // MARK: - Selector Methods
    @objc private func userViewTapped() {
        delegate?.didSelectAccountType("User")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func managerViewTapped() {
        delegate?.didSelectAccountType("Manager")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup Constraints
extension ChangeProfileViewController {
    func setupConstraints() {
        // Определение константы для удобства
        let inset: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 350),
            containerView.heightAnchor.constraint(equalToConstant: 244),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            userView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            userView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            userView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset),
            
            managerView.topAnchor.constraint(equalTo: userView.bottomAnchor, constant: 10),
            managerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            managerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset),
        ])
    }
}



