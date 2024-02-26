import UIKit

// MARK: - Image Creator

final class ImageCreator {
    
    private let imageFilter: ImageFilter = ImageFilter()
    
    init(image: CIImage) {
        imageFilter.setImage(image)
    }
    
    func updateImage(image: CIImage, by type: CorrectionType) {
        imageFilter.updateImage(image, by: type)
    }
    
    func correct(image: CIImage,
                 by types: (correction: CorrectionType, filter: FilterType),
                 for value: Int
    ) -> (filtered: CIImage, corrected: CIImage) {
        
        let outputValue = types.correction.params.getValue(by: value)
        let correctValue: Any = {
            
            switch types.correction {
                
            case .warmness, .coldness:
                return CIVector(x: outputValue, y: 0)
                
            default:
                return outputValue
            }
        }()
        
        let correctionFilter = imageFilter.getFilter(by: types.correction)
        
        correctionFilter.setValue(correctValue, forKey: types.correction.key)
        
        guard let outputImage = correctionFilter.outputImage, 
              let inputImage = correctionFilter.value(forKey: kCIInputImageKey) as? CIImage
        else {
            return (image, image)
        }
        
        let cropRect = inputImage.extent
        let croppedImage = outputImage.cropped(to: cropRect)
        
        guard let filter = imageFilter.getFilter(by: types.filter) else {
            return (croppedImage, croppedImage)
        }
        
        filter.setValue(croppedImage, forKey: kCIInputImageKey)
        
        guard let outputFilteredImage = filter.outputImage else {
            return (croppedImage, croppedImage)
        }
        
        return (outputFilteredImage, croppedImage)
    }
    
    func filter(image: CIImage, by filterType: FilterType) -> CIImage {
        guard let filter = imageFilter.getFilter(by: filterType) else {
            return image
        }
        
        guard let outputImage = filter.outputImage else {
            return image
        }
        
        return outputImage
    }
}
