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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let viewModel = viewModel else {
            return UICollectionReusableView()
        }
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeaderCell.reuseIdentifier, for: indexPath) as! CategoryHeaderCell
            
            if let categoryName = viewModel.categoryName(for: indexPath.section) {
                header.configure(with: categoryName)
            }
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if case .banner = viewModel.sectionType(indexPath.section) {
            if let product = viewModel.product(at: indexPath) {
                coordinator?.presentProductDetailScreen(product: product)
            }
        } else {
            if let product = viewModel.product(at: indexPath) {
                coordinator?.presentProductDetailScreen(product: product)
            }
        }
    }
}

