import UIKit

class BannerCell: UICollectionViewCell, CellInfo {
    static let reuseIdentifier = "BannerCell"
    
    private let bannerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(red: 255/255, green: 183/255, blue: 77/255, alpha: 1)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(bannerView)
        bannerView.addSubview(titleLabel)
        bannerView.addSubview(subtitleLabel)
        bannerView.addSubview(productImageView)
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            productImageView.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor),
            productImageView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor, constant: -24),
            productImageView.widthAnchor.constraint(equalToConstant: 120),
            productImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: bannerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bannerView.bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: HomeProduct) {
        titleLabel.text = product.title
        subtitleLabel.text = product.description ?? "Producto destacado de la semana."
        if let url = URL(string: product.imageUrl) {
            productImageView.setImage(from: url)
        }
    }
} 
