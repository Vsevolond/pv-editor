import UIKit

// MARK: - FeedCollectionHeaderView

final class FeedCollectionHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    private func setup() {
        backgroundColor = .clear
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
    }
    
    private func layout() {
        titleLabel.frame = .init(x: 20, y: 0, width: bounds.width, height: bounds.height)
        addSubview(titleLabel)
    }
}
