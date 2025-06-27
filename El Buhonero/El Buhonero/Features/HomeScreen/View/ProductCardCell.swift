import UIKit

class ProductCardCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCardCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.15, alpha: 1)
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.45, green: 0.6, blue: 0.13, alpha: 1) // olive green
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)
        cardView.addSubview(productImageView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            productImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: HomeProduct) {
        titleLabel.text = product.title
        priceLabel.text = String(format: "$%.2f", product.price)
        if let url = URL(string: product.imageUrl) {
            productImageView.setImage(from: url)
        }
    }
} 
