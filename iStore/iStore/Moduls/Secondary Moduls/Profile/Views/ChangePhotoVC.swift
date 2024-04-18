import UIKit

final class ChangePhotoViewController: UIViewController {
    
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
        element.text = "Change your Picture"
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
  
    private let takePhotoView = UIView.makeView(textLabel: "Take a Photo", 
                                                textColor: .black,
                                                nameMarker: "camera",
                                                colorMarker: .customDarkGray)
    
    private let chooseFromFileView = UIView.makeView(textLabel: "Choose from Your Files", 
                                                     textColor: .black,
                                                     nameMarker: "folder",
                                                     colorMarker: .customDarkGray)
    
    private let deletePhotoView = UIView.makeView(textLabel: "Delete Photo", 
                                                  textColor: .red,
                                                  nameMarker: "trash.fill",
                                                  colorMarker: .customRed)
    
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
        
        [titleLabel, takePhotoView, chooseFromFileView, deletePhotoView].forEach { containerView.addSubview($0) }
        
        //добавляем рекогнайзер на кнопки(вью)
        takePhotoView.isUserInteractionEnabled = true
        chooseFromFileView.isUserInteractionEnabled = true
        deletePhotoView.isUserInteractionEnabled = true

        let typeAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(takePhotoButtonTapped))
        takePhotoView.addGestureRecognizer(typeAccountTapGesture)

        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseFromFileButtonTapped))
        chooseFromFileView.addGestureRecognizer(termsTapGesture)

        let signoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(deletePhotoButtonTapped))
        deletePhotoView.addGestureRecognizer(signoutTapGesture)
    }
    
    // MARK: - Selector Methods
    @objc private func takePhotoButtonTapped() {
        print("takePhotoButton Tapped")
    }

    @objc private func chooseFromFileButtonTapped() {
        print("chooseFromFileButton Tapped")
    }

    @objc private func deletePhotoButtonTapped() {
        print("deletePhotoButton Tapped")
    }
}

// MARK: - Setup Constraints
extension ChangePhotoViewController {
    func setupConstraints() {
        // Определение константы для удобства
        let inset: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 350),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            takePhotoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            takePhotoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            takePhotoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset),
            
            chooseFromFileView.topAnchor.constraint(equalTo: takePhotoView.bottomAnchor, constant: 10),
            chooseFromFileView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            chooseFromFileView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset),
            
            deletePhotoView.topAnchor.constraint(equalTo: chooseFromFileView.bottomAnchor, constant: 10),
            deletePhotoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: inset),
            deletePhotoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -inset)
        ])
    }
}


