import UIKit

// MARK: - EditModeCollectionCell

final class EditModeCollectionCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private let correctionImageView: UIImageView = UIImageView()
    private let filterImageView: ImageMetalView = ImageMetalView()
    
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
        
        correctionImageView.image = nil
        filterImageView.image = nil
    }
    
    func configure(with mode: EditingMode, image: CIImage) {
        
        switch mode {
            
        case .correction(let type):
            setupLikeCorrection(type: type)
            
        case .filter(let type):
            setupLikeFilter(type: type, image: image)
            
        case .none:
            return
        }
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        backgroundColor = .clear
        clipsToBounds = true
        
        correctionImageView.frame = bounds
        addSubview(correctionImageView)
        
        filterImageView.frame = bounds
        addSubview(filterImageView)
    }
    
    private func setupLikeCorrection(type: CorrectionType) {
        filterImageView.isHidden = true
        correctionImageView.isHidden = false
        
        correctionImageView.image = type.image
        correctionImageView.contentMode = .center
        correctionImageView.tintColor = .white
        layer.cornerRadius = bounds.height / 2
        
        if isSelected {
            layer.borderWidth = 0
            correctionImageView.backgroundColor = .darkGray
        } else {
            correctionImageView.backgroundColor = .clear
            layer.borderWidth = 2
            layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    private func setupLikeFilter(type: FilterType, image: CIImage) {
        correctionImageView.isHidden = true
        filterImageView.isHidden = false
        
        filterImageView.image = ImageStaticFilters.getImage(by: type)
        layer.cornerRadius = 10
        
        if isSelected {
            layer.borderWidth = 2
            layer.borderColor = UIColor.appColor(.linen).cgColor
        } else {
            layer.borderWidth = 0
        }
    }
}
