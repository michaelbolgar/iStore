import UIKit

protocol ProductCollectionCellDelegate: AnyObject {
    func updateButtonPressed()
    func deleteButtonPressed()
}

final class ProductCollectionCell: UICollectionViewCell {
//MARK: - Properties
    var index: Int?
    static let identifier = String(describing: ProductCollectionCell.self)
    weak var delegate: ProductCollectionCellDelegate?
    let spacing: CGFloat = 12
    
    
   //MARK: - UI elements
    private lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
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
    func set(info: Product, at index: Int) {
        self.index = index
        let pictureName = info.picture ?? "Buy"
        productImage.image = UIImage(named: pictureName)
        productLabel.text = info.description
        priceLabel.text = String(format: "$%.2f", info.price ?? 0)
    }
   
    //MARK: - Private Methods
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
        delegate?.deleteButtonPressed()
    }
    
    @objc func updateButtonTapped() {
        delegate?.updateButtonPressed()
    }
}

//MARK: - Setup Constraints
private extension ProductCollectionCell {
    func setupConstraints() {
        backView.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            productImage.topAnchor.constraint(equalTo: backView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            productImage.heightAnchor.constraint(equalTo: backView.heightAnchor, multiplier: 0.5),
            
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


