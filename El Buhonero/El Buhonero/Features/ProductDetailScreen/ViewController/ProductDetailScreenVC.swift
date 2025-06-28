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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var buyButton: UIButton!
    
    // MARK: - Properties
    var coordinator: ProductDetailScreenCoordinator?
    var viewModel: ProductDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        loadingIndicator.isHidden = true
        loadingIndicator.hidesWhenStopped = true
        
        buyButton.setTitle("Buy", for: .normal)
        buyButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        buyButton.backgroundColor = UIColor(red: 0.45, green: 0.6, blue: 0.13, alpha: 1.0)
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.layer.cornerRadius = 25
        buyButton.layer.masksToBounds = true
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
    }
    
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
        
        viewModel.delegate = self
        
        if viewModel.hasProduct {
            updateUI(with: viewModel)
        } else {
            showLoadingState()
        }
    }
    
    private func updateUI(with viewModel: ProductDetailViewModel) {
        titleLabel.text = viewModel.productTitle
        priceLabel.text = viewModel.formattedPrice
        descriptionLabel.text = viewModel.formattedDescription
        categoryLabel.text = viewModel.categoryDisplayText
        idLabel.text = viewModel.idDisplayText
        productImageView.loadImage(from: viewModel.productImageUrl)
        
        hideLoadingState()
    }
    
    private func showLoadingState() {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        contentView.isHidden = true
    }
    
    private func hideLoadingState() {
        loadingIndicator.stopAnimating()
        contentView.isHidden = false
    }
    
    // MARK: - Coordinator and ViewModel Setup
    func setCoordinator(coordinator: ProductDetailScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
    }
    
    @objc private func buyButtonTapped() {
        guard let product = viewModel?.product else { return }
        coordinator?.presentPaymentScreen(product: product)
    }
}

// MARK: - ProductDetailViewModelDelegate
extension ProductDetailScreenVC: ProductDetailViewModelDelegate {
    func productLoaded(_ product: HomeProduct) {
        DispatchQueue.main.async {
            self.updateUI(with: self.viewModel!)
        }
    }
    
    func productLoadFailed(_ error: String) {
        DispatchQueue.main.async {
            self.hideLoadingState()
            self.showErrorAlert(message: error)
        }
    }
    
    func loadingStateChanged(_ isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.showLoadingState()
            } else {
                self.hideLoadingState()
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
} 
