//
//  OnboardingViewController.swift
//  TelegrameClone
//
//  Created by Lubomyr Chorniak on 04.05.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private var currentSlide = 0
    private lazy var strokeConst = CGFloat(1) / CGFloat(dataSource.count)
    private var fromValue: CGFloat = 0
    private let nextButtonStroke = CAShapeLayer()
    
    private let viewOutput: OnboardingViewOutput
    
    // MARK: - Data source
    private let dataSource: [PageItem] = [
        .init(title: "Telegram", text: "The world's fastest messaging app. It is free and secure.", backgroundColor: .purple, animationName: "logoAnimation"),
        .init(title: "Fast", text: "Telegram delivers messages faster than any other application.", backgroundColor: .systemPink, animationName: "rocketAnimation"),
        .init(title: "Free", text: "Telegram is free forever. No ads. No subscription fees.", backgroundColor: .brown, animationName: "giftAnimation"),
        .init(title: "Powerful", text: "Telegram has no limits on the size of your chats and media.", backgroundColor: .darkGray, animationName: "infinityAnimation"),
        .init(title: "Secure", text: "Telegram keeps your messages safe from hacker attacks", backgroundColor: .magenta, animationName: "secureAnimation"),
        .init(title: "Cloud-Based", text: "Telegram lets you access your messages from multiple devices.", backgroundColor: .orange, animationName: "cloudAnimation")
    ]
    
    // MARK: - Views
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height + UIWindow.topPadding + UIWindow.bottomPadding)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(PageCell.self, forCellWithReuseIdentifier: PageCell.cellId)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        collection.bouncesHorizontally = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var startMessagingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start Messaging", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font =  UIFont.Roboto.light.size(of: 20)
        button.addTarget(self, action: #selector(startMessagingButtonTapped), for: .touchUpInside)
        return button
    }()
    
     // MARK: - Init
    init(viewOutput: OnboardingViewOutput) {
        self.viewOutput = viewOutput
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupShape()
    }
    
    // MARK: - Setup
    private let pager = PageControl(numberOfPages: 6)
    
    private func setupViews() {
        view.backgroundColor = .red
        view.addSubview(collectionView)
        
        view.addSubview(nextButton)
        nextButton.addSubview(imageView)
        
        view.addSubview(startMessagingButton)
        view.addSubview(pager)
        pager.selectedPage = 0
    }
    
    private func setupShape() {
        let nextButtonStrokePath = UIBezierPath(arcCenter: CGPoint(x: 25, y: 25), radius: 23, startAngle: -(.pi / 2), endAngle: .pi + (.pi / 2), clockwise: true)
        nextButtonStroke.path = nextButtonStrokePath.cgPath
        nextButtonStroke.fillColor = UIColor.clear.cgColor
        nextButtonStroke.strokeColor = UIColor.white.cgColor
        nextButtonStroke.lineWidth = 3
        nextButtonStroke.lineCap = .round
        nextButtonStroke.strokeStart = 0
        nextButtonStroke.strokeEnd = strokeConst
        fromValue = strokeConst
        nextButton.layer.addSublayer(nextButtonStroke)
        
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.size.equalTo(50)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(45)
            make.center.equalToSuperview()
        }

        pager.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.bottom.equalTo(startMessagingButton.snp.top).offset(-20)
        }
        
        startMessagingButton.snp.makeConstraints { make in
            make.leading.equalTo(pager)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-9)
        }
    
    }
    
    // MARK: - Action handlers
    @objc private func startMessagingButtonTapped() {
        viewOutput.userDidFinishOnboarding()
    }
    
    @objc private func nextButtonTapped() {
        let maxSlide = dataSource.count
        
        if currentSlide < maxSlide - 1 {
            currentSlide += 1
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: IndexPath(item: currentSlide, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        } else {
            viewOutput.userDidFinishOnboarding()
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension OnboardingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PageCell else { return }
        cell.playAnimation()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PageCell else { return }
        cell.stopAnimation()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x > 0 else { return }
        let page = Int((scrollView.contentOffset.x + view.bounds.width / 2) / scrollView.frame.width)
        if pager.selectedPage != page {
            currentSlide = page 
            pager.selectedPage = page
            let currentStroke = strokeConst * CGFloat(page + 1)
            let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
            animation.fromValue = fromValue
            animation.toValue = currentStroke
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            animation.duration = 0.5
            nextButtonStroke.add(animation, forKey: "animation")
            fromValue = currentStroke
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.cellId, for: indexPath) as? PageCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(item: dataSource[indexPath.item])
        return cell
    }
    
}


