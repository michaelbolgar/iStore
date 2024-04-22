import UIKit

final class OnboardingVC: UIViewController {
    
    // MARK: UI Elements
    
    private let titles = ["20% Discount New Arrival Product", 
                          "Take Advantage Of The Offer Shopping", 
                          "All Types Offers Within Your Reactions"]
    private let descriptions = ["Don't miss out — unique prices on the latest arrivals!", 
                                "Everything you love is now available at great prices.", 
                                "Discover a variety of offers for every occasion!"]
    private let imageNames = ["1", 
                              "2", 
                              "3"]
    
    private var slides: [PagesView] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray3
        pageControl.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        pageControl.setIndicatorImage(UIImage(named: "minus"), forPage: 0)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var nextButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RightArrow")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextButtonTapped)))
        return imageView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurePages()
    }
    
    // MARK: Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(nextButtonImageView)
    }
    
    private func configurePages() {
        slides.forEach { $0.removeFromSuperview() }
        slides.removeAll()
        
        let scrollViewWidth = scrollView.frame.width
        let scrollViewHeight = scrollView.frame.height
        scrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(titles.count), height: scrollViewHeight)
        
        for (index, title) in titles.enumerated() {
            let slide = PagesView()
            slide.configure(title: title, description: descriptions[index], imageName: imageNames[index])
            slides.append(slide)
            scrollView.addSubview(slide)
            
            slide.frame = CGRect(x: scrollViewWidth * CGFloat(index), y: 0, width: scrollViewWidth, height: scrollViewHeight)
        }
    }
    
    private func updateActivePageIndicator() {
        let activeImage = UIImage(named: "minus")
        let currentPage = pageControl.currentPage
        for i in 0..<pageControl.numberOfPages {
            pageControl.setIndicatorImage(i == currentPage ? activeImage : nil, forPage: i)
        }
    }
    
    // MARK: Selector Methods
    
    @objc private func nextButtonTapped() {
        let currentPage = pageControl.currentPage
        let nextPage = currentPage + 1
        
        if nextPage < slides.count {
            let point = CGPoint(x: scrollView.frame.width * CGFloat(nextPage), y: 0)
            scrollView.setContentOffset(point, animated: true)
        } else {
            // Переход на экран Логина
//            let vc = LoginVC()
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
        }
    }
    
    @objc private func pageControlTapped(sender: UIPageControl) {
        let pageWidth = scrollView.frame.width
        let offsetX = CGFloat(sender.currentPage) * pageWidth
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

// MARK: Extensions

extension OnboardingVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.frame.width > 0 {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = pageIndex
            updateActivePageIndicator()
        }
    }
}

extension OnboardingVC {
    
    private func setupLayouts() {
        let edgePadding: CGFloat = 20
        let buttonSize: CGFloat = 70
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nextButtonImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgePadding),
            nextButtonImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -edgePadding),
            nextButtonImageView.widthAnchor.constraint(equalToConstant: buttonSize),
            nextButtonImageView.heightAnchor.constraint(equalToConstant: buttonSize),
            
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: edgePadding),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -edgePadding)
        ])
    }
}
