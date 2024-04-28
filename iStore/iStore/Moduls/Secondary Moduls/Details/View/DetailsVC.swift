import UIKit

protocol DetailsVCProtocol:AnyObject {
    func displayDetails()
}

final class DetailsVC: UIViewController, DetailsVCProtocol, UITextViewDelegate, UIScrollViewDelegate {
    // MARK: Properties

    var presenter: DetailsPresenter!

    var data: SingleProduct 

      init(data: SingleProduct) {
          self.data = data
          super.init(nibName: nil, bundle: nil)
      }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.presenter.getData(with: [data])
     }

    // MARK: UI Elements

    private let priceLabel = UILabel.makeLabel(text: "",
                                               font: UIFont.InterBold(ofSize: 16),
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
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()

    private let productNameLabel = UILabel.makeLabel(text: "",
                                               font: UIFont.InterMedium(ofSize: 18),
                                               textColor: UIColor.darkGray,
                                               numberOfLines: 1,
                                               alignment: .left)

    private let descriptionTextView = UILabel.makeLabel(text: nil, 
                                                        font: UIFont.InterRegular(ofSize: 14),
                                                        textColor: UIColor.darkGray,
                                                        numberOfLines: 0,
                                                        alignment: .justified)

    private let grayCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1)
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        return view
    }()

    private let heartButton = UIButton.makeImageButton(imageForNormal: UIImage.heart,
                                                       imageForSelected: UIImage.selectedheart, 
                                                       color: .lightGreen)

    @objc private let addButton = UIButton.makeButton(text: "Add to Cart", 
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
 //       presenter.getData()
        setNavigationBar(title: "Product details")
        navigationController?.isNavigationBarHidden = false
        setupViews()
        configureController()
        setupConstraints()
        addBorder(y: 705)
        setupButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        grayCircle.layer.cornerRadius = grayCircle.frame.size.width / 2
        addButton.layer.cornerRadius = 4
        buyButton.layer.cornerRadius = 4
    }

    // MARK: Private Methods

    private func setupViews() {
        [contentImage, productNameLabel, descriptionTextView, priceLabel, descriptionProductlabel, grayCircle ].forEach {contentView.addSubview($0) }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        grayCircle.addSubview(heartButton)
        [addButton, buyButton].forEach{view.addSubview($0)}
    }
    private func configureController() {
        scrollView.contentInsetAdjustmentBehavior = .never
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }


    func displayDetails() {
        DispatchQueue.main.async {
            self.priceLabel.text = "$ \(self.data.price ?? 100)"
            self.productNameLabel.text = self.data.title
            self.descriptionTextView.text = self.data.description

            guard let imageURL = self.data.images.first else { return }
            guard let imageName = URL(string: imageURL ?? "https://ionicframework.com/docs/img/demos/thumbnail.svg") else { return }

            ImageDownloader.shared.downloadImage(from: imageName) { result in
                switch result {
                case .success(let image):
                    self.contentImage.image = image
                case .failure(let error):
                    print("Error fetching image: \(error)")
                }
            }
        }
    }
    private func addBorder(y: CGFloat) {
         let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: 1.0)
         borderLayer.backgroundColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(borderLayer)
     }

    private func setupButtons() {
        buyButton.addTarget(self, action: #selector(buyNowAction), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
    }

    // MARK: Selector Methods

    @objc func heartButtonTapped() {
        heartButton.isSelected = !heartButton.isSelected
    }

    @objc func buyNowAction() {
        print("buy now tapped")

    }

    @objc func addToCartAction() {
        print("add cart tapped")
    }
}

    // MARK: Layout

private extension DetailsVC {

    private func setupConstraints() {

        [scrollView, contentView, contentImage, descriptionTextView, grayCircle, heartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -162),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            contentImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            contentImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentImage.heightAnchor.constraint(equalToConstant: 286),

            productNameLabel.topAnchor.constraint(equalTo: contentImage.bottomAnchor, constant: 15),
            productNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productNameLabel.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor, constant: -60),

            priceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            descriptionProductlabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 15),
            descriptionProductlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionProductlabel.bottomAnchor, constant: 6),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100),

            grayCircle.heightAnchor.constraint(equalToConstant: 46),
            grayCircle.widthAnchor.constraint(equalToConstant: 46),
            grayCircle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            grayCircle.topAnchor.constraint(equalTo: contentImage.bottomAnchor, constant: 9),

            heartButton.heightAnchor.constraint(equalToConstant: 26),
            heartButton.widthAnchor.constraint(equalToConstant: 26),
            heartButton.centerXAnchor.constraint(equalTo: grayCircle.centerXAnchor),
            heartButton.centerYAnchor.constraint(equalTo: grayCircle.centerYAnchor),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),

            buyButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
        ])
    }
}
