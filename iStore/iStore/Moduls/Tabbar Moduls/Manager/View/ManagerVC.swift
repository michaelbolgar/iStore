import UIKit

protocol ManagerVCProtocol: AnyObject {

}

final class ManagerVC: UIViewController {
    
    var presenter: ManagerPresenterProtocol!
    
    // MARK: - UI Elements
    private let productView = UIView.makeView(textLabel: "Product",
                                                  textColor: .customDarkGray,
                                                  nameMarker: "chevron.forward",
                                                  colorMarker: .customDarkGray)
    
    private let categoryView = UIView.makeView(textLabel: "Category",
                                            textColor: .customDarkGray,
                                            nameMarker: "chevron.forward",
                                            colorMarker: .customDarkGray)
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    //MARK: Private Methods
    private func setupViews() {
        
        view.backgroundColor = .white
     
        [productView, categoryView].forEach { view.addSubview($0) }
        
        setNavigationBar(title: "Manager")
        navigationController?.isNavigationBarHidden = false
    
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customDarkGray, NSAttributedString.Key.font: UIFont.InterBold(ofSize: 18)]
        
        //добавляем рекогнайзер на кнопки(вью)
       // managerTitle.isUserInteractionEnabled = true
        productView.isUserInteractionEnabled = true
        categoryView.isUserInteractionEnabled = true
        
        let typeAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(productViewTapped))
        productView.addGestureRecognizer(typeAccountTapGesture)
        
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryViewTapped))
        categoryView.addGestureRecognizer(termsTapGesture)
    }
    
    // MARK: Selector Methods
    @objc private func productViewTapped() {
        guard let presenter = presenter else {
                print("Error: Presenter is nil")
                return
            }
            presenter.showProductManagerVC()
    }
    
    @objc private func categoryViewTapped() {
        presenter?.showCategoryManagerVC()
    }
}

// MARK: - Setup Constraints
private extension ManagerVC {
    
    func setupConstraints() {
        // Определение константы для удобства
        let inset: CGFloat = 20
        
        NSLayoutConstraint.activate([
           
            productView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            productView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            productView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            categoryView.topAnchor.constraint(equalTo: productView.bottomAnchor, constant: 28),

        ])
    }
}

extension ManagerVC: ManagerVCProtocol {

}
