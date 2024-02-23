import UIKit

// MARK: - Image Filter

final class ImageFilter {
    
    init(image: CIImage) {
        setImage(image)
    }
    
    private func setImage(_ image: CIImage) {
        ImageAdjustFilters.setImage(image)
        ImageStaticFilters.setImage(image)
    }
    
    func updateImage(_ image: CIImage, by type: CorrectionType) {
        ImageAdjustFilters.updateImage(image, by: type)
        ImageStaticFilters.setImage(image)
    }
    
    func getFilter(by type: CorrectionType) -> CIFilter { ImageAdjustFilters.getFilter(by: type) }
    
    func getFilter(by type: FilterType) -> CIFilter? { ImageStaticFilters.getFilter(by: type) }
    
    
}


