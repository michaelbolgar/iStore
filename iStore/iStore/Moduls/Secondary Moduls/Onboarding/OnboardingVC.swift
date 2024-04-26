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
    private var lastAnimatedPageIndex: Int?
    
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
        TestUD() // Тест Удалить
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !slides.isEmpty {
            slides[0].animateContentEntrance()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configurePages()
    }
    
    // MARK: Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        [scrollView, pageControl, nextButtonImageView].forEach { view.addSubview($0) }
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
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.setContentOffset(point, animated: false)
            }) { _ in
                self.scrollViewDidEndDecelerating(self.scrollView)
            }
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateContentAndAnimationsForPage(_ pageIndex: Int) {
        if pageIndex != lastAnimatedPageIndex {
            slides[pageIndex].animateContentEntrance()
            lastAnimatedPageIndex = pageIndex
        }
    }
    
    @objc private func pageControlTapped(sender: UIPageControl) {
        let pageWidth = scrollView.frame.width
        let offsetX = CGFloat(sender.currentPage) * pageWidth
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        updateActivePageIndicator()
    }
}

// MARK: Extensions

extension OnboardingVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newPageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if scrollView.frame.width > 0 && pageControl.currentPage != newPageIndex {
            pageControl.currentPage = newPageIndex
           updateActivePageIndicator()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        updateContentAndAnimationsForPage(pageIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        updateContentAndAnimationsForPage(pageIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        slides.forEach { slide in
            slide.layer.removeAllAnimations()
            slide.resetAnimations()
        }
    }
}

extension OnboardingVC {
    
    private func setupLayouts() {
        let edgePadding: CGFloat = 20
        let buttonSize: CGFloat = 50
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nextButtonImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -edgePadding),
            nextButtonImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -edgePadding),
            nextButtonImageView.widthAnchor.constraint(equalToConstant: buttonSize),
            nextButtonImageView.heightAnchor.constraint(equalToConstant: buttonSize),
            
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -edgePadding + 5),
            pageControl.centerYAnchor.constraint(equalTo: nextButtonImageView.centerYAnchor)
        ])
    }
}
// Тест Удалить
private func TestUD() {
    let defaultsManager = UserDefaultsManager()
    
    defaultsManager.addSearchQuery("Я")
    defaultsManager.addSearchQuery("люблю")
    defaultsManager.addSearchQuery("пиво")
    defaultsManager.printSearchHistory()
    defaultsManager.clearSearchHistory()
    defaultsManager.printSearchHistory()
}
