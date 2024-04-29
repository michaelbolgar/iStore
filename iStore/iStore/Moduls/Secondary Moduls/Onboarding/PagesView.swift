import UIKit

class PagesView: UIView {
    
    // MARK: UI Elements
    
    var isAnimated = false
    
    private lazy var titleLabel = UILabel.makeLabel(text: nil, 
                                                    font: .InterBold(ofSize: 30), 
                                                    textColor: .black, 
                                                    numberOfLines: 0, 
                                                    alignment: .left)
    
    private lazy var descriptionLabel = UILabel.makeLabel(text: nil, 
                                                          font: .InterRegular(ofSize: 16), 
                                                          textColor: .customDarkGray, 
                                                          numberOfLines: 0, 
                                                          alignment: .left)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {

        [imageView, titleLabel, descriptionLabel].forEach { self.addSubview($0) }
    }
    
    // MARK: Configuration Pages
    
    func configure(title: String, description: String, imageName: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        imageView.image = UIImage(named: imageName)
        resetAnimations()
    }
    
    func animateContentEntrance(completion: (() -> Void)? = nil) {
        guard !isAnimated else { return }
        isAnimated = true
        
        // Начальное положение элементов
        resetAnimations()
        
        // Анимация для titleLabel
        UIView.animate(withDuration: 1.0,
                       delay: 0.2,
                       options: [.curveEaseOut], 
                       animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }, completion: nil)
        
        // Анимация для descriptionLabel
        UIView.animate(withDuration: 1.0,
                       delay: 0.4,
                       options: [.curveEaseOut], 
                       animations: {
            self.descriptionLabel.alpha = 1
            self.descriptionLabel.transform = .identity
        }, completion: nil)
        
        // Анимация для imageView
        UIView.animate(withDuration: 1.0,
                       delay: 0.6,
                       options: [.curveEaseOut], 
                       animations: {
            self.imageView.alpha = 1
            self.imageView.transform = .identity
        }, completion: nil)
    }
}

// MARK: Extensions

extension PagesView {
    
    private func setupLayout() {
        let imageSidePadding: CGFloat = 15
        let imageTopPadding: CGFloat = 5
        let labelBottomPadding: CGFloat = 90
        let labelSidePadding: CGFloat = 20
        let labelToLabelSpacing: CGFloat = 10
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: imageSidePadding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -imageSidePadding),
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: imageTopPadding),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -labelBottomPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelSidePadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -labelSidePadding),
            
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -labelToLabelSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelSidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -labelSidePadding)
        ])
    }
}

extension PagesView {
    func resetAnimations() {
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 300, y: 0)
        descriptionLabel.alpha = 0
        descriptionLabel.transform = CGAffineTransform(translationX: 300, y: 0)
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(translationX: 0, y: -300)
    }
}
