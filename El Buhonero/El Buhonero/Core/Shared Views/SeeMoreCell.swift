import UIKit

class SeeMoreCell: UICollectionViewCell {
    static let reuseIdentifier = "SeeMoreCell"
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 239/255, blue: 200/255, alpha: 1) // light orange
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        return view
    }()
    
    private let plusIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus.circle.fill")
        imageView.tintColor = UIColor(red: 255/255, green: 183/255, blue: 77/255, alpha: 1) // orange
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ver más"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(red: 44/255, green: 36/255, blue: 28/255, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.addSubview(cardView)
        cardView.addSubview(plusIcon)
        cardView.addSubview(label)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            plusIcon.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            plusIcon.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            plusIcon.widthAnchor.constraint(equalToConstant: 32),
            plusIcon.heightAnchor.constraint(equalToConstant: 32),
            
            label.topAnchor.constraint(equalTo: plusIcon.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        // Nothing dynamic for now
    }
} 