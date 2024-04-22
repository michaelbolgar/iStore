import UIKit

class PagesView: UIView {
    
    // MARK: UI Elements
    
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
    }
}

// MARK: Layout extension

extension PagesView {
    
    private func setupLayout() {
        let imageTopPadding: CGFloat = 15
        let labelBottomPadding: CGFloat = 90
        let labelSidePadding: CGFloat = 20
        let labelToLabelSpacing: CGFloat = 10
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: imageTopPadding),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -imageTopPadding),
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
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
