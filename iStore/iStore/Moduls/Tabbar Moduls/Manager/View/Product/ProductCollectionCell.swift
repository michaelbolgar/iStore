import UIKit

protocol ProductCollectionCellDelegate: AnyObject {
    func updateButtonPressed(with product: SingleProduct)
    func deleteButtonPressed(with product: SingleProduct)
}

final class ProductCollectionCell: UICollectionViewCell {
//MARK: - Properties
    var product: SingleProduct?
    var index: Int?
    static let identifier = String(describing: ProductCollectionCell.self)
    var presenter: ProductPresenter!
    weak var delegate: ProductCollectionCellDelegate?
    let spacing: CGFloat = 12
    
    
   //MARK: - UI elements
    private lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var productLabel = UILabel.makeLabel(text: nil,
                                                      font: UIFont.InterRegular(ofSize: 12),
                                                      textColor: UIColor.darkGray,
                                                      numberOfLines: 2,
                                                      alignment: .left)
    
    private lazy var priceLabel = UILabel.makeLabel(text: nil,
                                                    font: UIFont.InterSemiBold(ofSize: 14),
                                                    textColor: UIColor.customDarkGray,
                                                    numberOfLines: 1,
                                                    alignment: .left)
    
    private let deleteButton = UIButton.makeButtonFlexWidth(text: "Delete",
                                                            buttonColor: .red,
                                                         titleColor: .white,
                                                         titleSize: 12,
                                                         height: 31,
                                                         cornerRadius: 4)
    
    private let updateButton = UIButton.makeButtonFlexWidth(text: "Update",
                                                            buttonColor: .green,
                                                         titleColor: .white,
                                                         titleSize: 12,
                                                         height: 31,
                                                         cornerRadius: 4)
    
    
    private let backView = UIView.makeGreyView(cornerRadius: 6)

    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //MARK: - Methods
    func set(info: SingleProduct, at index: Int) {
        self.index = index
        productImage.image = nil
        if let pictureName = info.images.first {
            if let unwrappedPictureName = pictureName {
                setImage(pictureURL: unwrappedPictureName)
            }
        }
        productLabel.text = info.title
        priceLabel.text = "$\(info.price ?? 0)"
        
    }
    
    
    //MARK: - Private Methods
    private func setImage(pictureURL: String) {
        
        guard let imageURL = URL(string: pictureURL) else { return }
        
        ImageDownloader.shared.downloadImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                //                print("success")
                self.productImage.image = image
            case .failure(let error):
                print("Error fetching image: \(error)")
            }
        }
    }
    
    private func configure() {
        contentView.addSubview(backView)
        [productImage, productLabel, updateButton, deleteButton, priceLabel].forEach { backView.addSubview($0)}
    }
    
    private func addTargets() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }

    //MARK: - Selector Methods
    @objc func deleteButtonTapped() {
        guard let product = product else { return }
        presenter.deleteButtonPressed(with: product)
    }
    
    @objc func updateButtonTapped() {
        guard let product = product else { return }
        presenter.updateButtonPressed(with: product)
    }

}

//MARK: - Setup Constraints
private extension ProductCollectionCell {
    func setupConstraints() {
        
        productImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            productImage.topAnchor.constraint(equalTo: backView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            productImage.widthAnchor.constraint(equalToConstant: 170),
            productImage.heightAnchor.constraint(equalToConstant: 112),
            
            productLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: spacing),
            productLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -spacing),
            productLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: spacing),
            
            priceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: spacing),
            priceLabel.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -spacing / 2),
            
            updateButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: spacing),
            updateButton.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
            updateButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 1.2/3),
            
            deleteButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -spacing),
            deleteButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 1.2/3),
            deleteButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -spacing)
        ])
    }
}
