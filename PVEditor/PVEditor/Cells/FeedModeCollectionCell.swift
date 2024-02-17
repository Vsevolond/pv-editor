import UIKit

// MARK: - FeedModeCollectionCell

final class FeedModeCollectionCell: UICollectionViewCell {
    
    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        backgroundColor = backgroundColor?.withAlphaComponent(0.6)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = backgroundColor?.withAlphaComponent(1)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = backgroundColor?.withAlphaComponent(1)
    }
    
    func configure(with type: FeedCellType) {
        backgroundColor = type.backgroundColor
        
        imageView.image = type.image
        imageView.tintColor = type.tintColor
        
        titleLabel.text = type.title
        titleLabel.textColor = type.tintColor
    }
    
    private func setup() {
        layer.cornerRadius = 20
        layer.shadowRadius = 20
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        titleLabel.backgroundColor = .clear
    }
    
    private func layout() {
        imageView.frame = .init(x: 10, y: 10, width: bounds.height - 20, height: bounds.height - 20)
        addSubview(imageView)
        
        titleLabel.frame = .init(x: imageView.frame.maxX + 20, y: imageView.frame.minY,
                                 width: bounds.width - imageView.frame.maxX - 20, height: imageView.frame.height)
        addSubview(titleLabel)
    }
}
