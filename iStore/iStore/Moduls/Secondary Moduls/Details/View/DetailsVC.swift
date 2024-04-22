import UIKit

protocol DetailsVCProtocol:AnyObject {
    func displayDetails(for product: DetailsModel)
}

final class DetailsVC: UIViewController, DetailsVCProtocol, UITextViewDelegate, UIScrollViewDelegate {
    var presenter: DetailsPresenter!

    //MARK: -> Properties
    private let priceLabel = UILabel.makeLabel(text: "",
                                               font: UIFont.InterMedium(ofSize: 16),
                                               textColor: UIColor.darkGray,
                                               numberOfLines: 1,
                                               alignment: .left)

    private let descriptionProductlabel = UILabel.makeLabel(text: "Description of product", 
                                                            font: UIFont.InterMedium(ofSize: 16),
                                                            textColor: UIColor.darkGray,
                                                            numberOfLines: 1,
                                                            alignment: .left)

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let contentImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    private let titleLabel = UILabel.makeLabel(text: "", 
                                               font: UIFont.InterMedium(ofSize: 16),
                                               textColor: UIColor.darkGray,
                                               numberOfLines: 1,
                                               alignment: .left)

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.InterRegular(ofSize: 12)
        textView.textColor = UIColor.darkGray
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()

    private let grayCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1)
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()

    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .selected)
        return button
    }()

    private let addButton = UIButton.makeButton(text: "Add to Cart", 
                                                buttonColor: ButtonColor.green,
                                                titleColor: .white,
                                                titleSize: 14,
                                                width: 167,
                                                height: 45)

    private let buyButton = UIButton.makeButton(text: "Buy Now", 
                                                buttonColor: ButtonColor.gray,
                                                titleColor: .white,
                                                titleSize: 14,
                                                width: 167,
                                                height: 45)

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter = DetailsPresenter(view: self)
        presenter.getData()
        title = "Details product"
        setupViews()
        configureController()
        setupConstraints()
        addBorder(y: 725)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        grayCircle.layer.cornerRadius = grayCircle.frame.size.width / 2
    }

    // MARK: Private Methods
    private func setupViews() {
        [contentImage, titleLabel, contentTextView, priceLabel, descriptionProductlabel, grayCircle ].forEach {contentView.addSubview($0) }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        grayCircle.addSubview(heartButton)
        [addButton, buyButton].forEach{view.addSubview($0)}
    }
    private func configureController() {
        contentTextView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }

    func displayDetails(for product: DetailsModel) {
          priceLabel.text = "$ \(product.priceLabel)"

        contentImage.image = UIImage(named: product.productImage)
        titleLabel.text = product.productLabel
        contentTextView.text = product.descriptionProduct
    }
    private func addBorder(y: CGFloat) {
         let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: 1.0)
         borderLayer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(borderLayer)
     }

    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentImage.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        grayCircle.translatesAutoresizingMaskIntoConstraints = false
        heartButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -132),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            contentImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            contentImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentImage.heightAnchor.constraint(equalToConstant: 286),

            titleLabel.topAnchor.constraint(equalTo: contentImage.bottomAnchor, constant: 9),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionProductlabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            descriptionProductlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionProductlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            contentTextView.topAnchor.constraint(equalTo: descriptionProductlabel.bottomAnchor, constant: 6),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),

            grayCircle.heightAnchor.constraint(equalToConstant: 46),
            grayCircle.widthAnchor.constraint(equalToConstant: 46),
            grayCircle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            grayCircle.topAnchor.constraint(equalTo: contentImage.bottomAnchor, constant: 9),

            heartButton.heightAnchor.constraint(equalToConstant: 26),
            heartButton.widthAnchor.constraint(equalToConstant: 26),
            heartButton.centerXAnchor.constraint(equalTo: grayCircle.centerXAnchor),
            heartButton.centerYAnchor.constraint(equalTo: grayCircle.centerYAnchor),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -63),

            buyButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
        ])
    }

    // MARK: Selector Methods
    @objc func heartButtonTapped() {
        heartButton.isSelected = !heartButton.isSelected
    }

}
