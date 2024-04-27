import UIKit

class SuccessViewController: UIViewController {
    
    // MARK: UI Elements
    
    private lazy var cangratulationsLabel = UILabel.makeLabel(text: "Congrats! Your payment Successfully", 
                                                              font: .InterBold(ofSize: 20), 
                                                              textColor: .black, 
                                                              numberOfLines: 0, 
                                                              alignment: .center)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.seal.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .lightGreen
        return imageView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        button.titleLabel?.font = UIFont.InterBold(ofSize: 25)
        return button
    }()
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayouts()
        if let parentVC = presentingViewController {
            self.preferredContentSize = CGSize(width: parentVC.view.bounds.width, 
                                               height: parentVC.view.bounds.height / 2)
        }
    }
    
    //MARK: Private methods
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(cangratulationsLabel)
        view.addSubview(continueButton)
        
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.clipsToBounds = true
        
        let views = [imageView, cangratulationsLabel, continueButton]
        
        views.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            cangratulationsLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            cangratulationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cangratulationsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            continueButton.topAnchor.constraint(equalTo: cangratulationsLabel.bottomAnchor, constant: 20),
            
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: Selector methods
    
    @objc func dismissAlert() {
        if let paymentVC = presentingViewController as? PaymentVC {
            UIView.animate(withDuration: 0.3) {
                paymentVC.dimmingView.alpha = 0
            }
        }
        self.dismiss(animated: true)
    }
}

