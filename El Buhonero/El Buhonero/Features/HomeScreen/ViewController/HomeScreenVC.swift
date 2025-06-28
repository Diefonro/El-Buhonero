//
//  HomeScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class HomeScreenVC: UIViewController, StoryboardInfo {
    
    static var storyboard = "HomeScreen"
    static var identifier = "HomeScreenVC"
    
    // MARK: - IBOutlets
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var chevronDownImage: UIImageView!
    
    var collectionView: UICollectionView!
    var viewModel: HomeScreenViewModel?
    var coordinator: HomeScreenCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayCountryInfo()
        setupCollectionView()
        setupBottomNavBar()
        setupCountrySelection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayCountryInfo()
        hideNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    func setCoordinator(coordinator: HomeScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
        viewModel.onDataLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        collectionView?.reloadData()
    }
    
    func setupCountrySelection() {
        chevronDownImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(countryLabelTapped))
        chevronDownImage.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Display Country Info
    private func displayCountryInfo() {
        let dataManager = DataManager.shared
        countryLabel.text = dataManager.getSelectedCountryName()
    }
    
    // MARK: - Collection View Setup
    private func setupCollectionView() {
        let layout = createCompositionalLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionViewContainer.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: collectionViewContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: collectionViewContainer.trailingAnchor)
        ])
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        collectionView.register(ProductCardCell.self, forCellWithReuseIdentifier: ProductCardCell.reuseIdentifier)
        collectionView.register(CategoryHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderCell.reuseIdentifier)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self, let sectionType = self.viewModel?.sectionType(sectionIndex) else { return nil }
            switch sectionType {
            case .banner:
                return Self.bannerSectionLayout()
            case .category:
                return Self.productSectionLayout(withHeader: true)
            case .uncategorized:
                return Self.productSectionLayout(withHeader: true)
            }
        }
    }
    
    private static func bannerSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(220))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 32, trailing: 0)
        return section
    }
    
    private static func productSectionLayout(withHeader: Bool) -> NSCollectionLayoutSection {
        let cardWidth: CGFloat = 150
        let cardHeight: CGFloat = 300
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(cardWidth), heightDimension: .absolute(cardHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(cardWidth * 5 + 8 * 6), heightDimension: .absolute(cardHeight + 16))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 0)
        
        // Add header for category sections
        if withHeader {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    
    // MARK: - Bottom Nav Bar
    private func setupBottomNavBar() {
        let navBar = UIView()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
        navBar.layer.cornerRadius = 24
        navBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(navBar)
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            navBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            navBar.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        // QR Button
        let qrButton = UIButton(type: .system)
        qrButton.translatesAutoresizingMaskIntoConstraints = false
        qrButton.setImage(UIImage(systemName: "qrcode.viewfinder"), for: .normal)
        qrButton.tintColor = .white
        qrButton.addTarget(self, action: #selector(qrButtonTapped), for: .touchUpInside)
        navBar.addSubview(qrButton)
        
        // Purchase History Button
        let historyButton = UIButton(type: .system)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        historyButton.setImage(UIImage(systemName: "clock.arrow.circlepath"), for: .normal)
        historyButton.tintColor = .white
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
        navBar.addSubview(historyButton)
        
        // Logout Button
        let logoutButton = UIButton(type: .system)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.tintColor = .white
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        navBar.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            qrButton.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
            qrButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            qrButton.widthAnchor.constraint(equalToConstant: 32),
            qrButton.heightAnchor.constraint(equalToConstant: 32),
            
            historyButton.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            historyButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            historyButton.widthAnchor.constraint(equalToConstant: 32),
            historyButton.heightAnchor.constraint(equalToConstant: 32),
            
            logoutButton.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 32),
            logoutButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @IBAction func qrButtonTapped(_ sender: UIButton) {
        coordinator?.presentQRScanScreen()
    }
    
    @objc private func historyButtonTapped() {
        coordinator?.presentPurchaseHistoryScreen()
    }
    
    @objc private func logoutButtonTapped() {
        DataManager.shared.clearLoginState()
        coordinator?.presentSelectCountryScreenForLogout()
    }
    
    @objc private func countryLabelTapped() {
        coordinator?.presentSelectCountryScreen { [weak self] in
            guard let self = self, let viewModel = self.viewModel else { return }
            viewModel.reloadData()
            self.displayCountryInfo()
            self.collectionView.reloadData()
        }
    }
    
    private func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
