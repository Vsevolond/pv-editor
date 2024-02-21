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
        correctionImageView.layer.cornerRadius = bounds.height / 2
        
        if isSelected {
            correctionImageView.layer.borderWidth = 0
            correctionImageView.backgroundColor = .darkGray
        } else {
            correctionImageView.backgroundColor = .clear
            correctionImageView.layer.borderWidth = 2
            correctionImageView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    private func setupLikeFilter(type: FilterType, image: CIImage) {
        correctionImageView.isHidden = true
        filterImageView.isHidden = false
        
        let filters = ImageFilters(image: image)
        if let filter = filters.getFilter(by: type) {
            filterImageView.image = filter.outputImage
        } else {
            filterImageView.image = image
        }
        filterImageView.layer.cornerRadius = 10
        
        if isSelected {
            filterImageView.layer.borderWidth = 2
            filterImageView.layer.borderColor = UIColor.appColor(.linen).cgColor
        } else {
            filterImageView.layer.borderWidth = 0
        }
    }
}
