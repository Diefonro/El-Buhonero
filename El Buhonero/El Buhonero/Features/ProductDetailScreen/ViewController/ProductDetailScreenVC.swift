//
//  ProductDetailScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class ProductDetailScreenVC: UIViewController, StoryboardInfo {
    
    static var storyboard = "ProductDetailScreen"
    static var identifier = "ProductDetailScreenVC"
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var productImageView: LoadingImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    // MARK: - Properties
    var coordinator: ProductDetailScreenCoordinator?
    var viewModel: ProductDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWithViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        
        if let title = viewModel?.navigationTitle {
            navigationItem.title = title
        }
    }
    
    private func configureWithViewModel() {
        guard let viewModel = viewModel else { return }
        
        titleLabel.text = viewModel.productTitle
        priceLabel.text = viewModel.formattedPrice
        descriptionLabel.text = viewModel.formattedDescription
        categoryLabel.text = viewModel.categoryDisplayText
        idLabel.text = viewModel.idDisplayText
        
        productImageView.loadImage(from: viewModel.productImageUrl)
    }
    
    // MARK: - Coordinator and ViewModel Setup
    func setCoordinator(coordinator: ProductDetailScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
    }
} 
