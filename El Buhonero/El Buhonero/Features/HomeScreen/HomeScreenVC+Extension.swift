//
//  HomeScreenVC+Extension.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeScreenVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return UICollectionViewCell()
        }
        let sectionType = viewModel.sectionType(indexPath.section)
        if viewModel.isSeeMoreCell(at: indexPath) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeMoreCell.reuseIdentifier, for: indexPath) as! SeeMoreCell
            cell.configure()
            return cell
        }
        switch sectionType {
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as! BannerCell
            if let product = viewModel.product(at: indexPath) {
                cell.configure(with: product)
            }
            return cell
        case .category:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCardCell.reuseIdentifier, for: indexPath) as! ProductCardCell
            if let product = viewModel.product(at: indexPath) {
                cell.configure(with: product)
            }
            return cell
        case .uncategorized:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCardCell.reuseIdentifier, for: indexPath) as! ProductCardCell
            if let product = viewModel.product(at: indexPath) {
                cell.configure(with: product)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if viewModel.isSeeMoreCell(at: indexPath) {
            if let category = viewModel.categoryName(for: indexPath.section) {
                print("See more tapped for category: \(category)")
            } else {
                print("See more tapped for uncategorized products")
            }
        } else if case .banner = viewModel.sectionType(indexPath.section) {
            if let product = viewModel.product(at: indexPath) {
                print("Banner tapped: \(product.title)")
            }
        } else {
            if let product = viewModel.product(at: indexPath) {
                print("Product tapped: \(product.title)")
            }
        }
    }
}

