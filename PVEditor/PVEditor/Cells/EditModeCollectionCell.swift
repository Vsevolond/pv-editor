import UIKit

// MARK: - EditModeCollectionCell

final class EditModeCollectionCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let imageView: UIImageView = UIImageView()
    private let valueLabel: UILabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        valueLabel.text = nil
    }
    
    func configure(with mode: EditingMode) {
        valueLabel.isHidden = true
        imageView.isHidden = false
        
        switch mode {
            
        case .correction(let type):
            setupLikeCorrection(type: type)
            
        case .filter(let type):
            setupLikeFilter(type: type)
            
        case .none:
            return
        }
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        backgroundColor = .clear
        
        valueLabel.frame = bounds
        addSubview(valueLabel)
        
        imageView.frame = bounds
        addSubview(imageView)
    }
    
    private func setupLikeCorrection(type: CorrectionType) {
        imageView.image = type.image
        imageView.contentMode = .center
        imageView.tintColor = .white
        imageView.layer.cornerRadius = bounds.height / 2
        
        if isSelected {
            imageView.layer.borderWidth = 0
            imageView.backgroundColor = .darkGray
        } else {
            imageView.backgroundColor = .clear
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    private func setupLikeFilter(type: FilterType) {
        imageView.image = type.image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        if isSelected {
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = UIColor.appColor(.linen).cgColor
        } else {
            imageView.layer.borderWidth = 0
        }
    }
}
