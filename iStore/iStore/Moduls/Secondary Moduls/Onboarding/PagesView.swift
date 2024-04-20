import UIKit

class PagesView: UIView {
    
    // MARK: UI Elements
    
    private lazy var titleLabel = UILabel.makeLabel(text: nil, 
                                                    font: .InterBold(ofSize: 30), 
                                                    textColor: .black, numberOfLines: 0, 
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
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
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
        let topImageConstraint: CGFloat = 60
        let imageSize: CGFloat = 300
        let labelTopPadding: CGFloat = 20
        let labelSidePadding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: topImageConstraint),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: labelTopPadding),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelSidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -labelSidePadding),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: labelTopPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: labelSidePadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -labelSidePadding)
        ])
    }
}
