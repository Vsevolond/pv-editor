import UIKit

// MARK: - Image Filters

struct ImageFilters {
    
    let cbsFilter: CIFilter = .init(name: Constants.cbsFilterName)!
    let tempFilter: CIFilter = .init(name: Constants.tempFilterName)!
    let sharpFilter: CIFilter = .init(name: Constants.sharpFilterName)!
    let clearFilter: CIFilter = .init(name: Constants.clearFilterName)!
    let blurFilter: CIFilter = .init(name: Constants.blurName)!
    
    init(image: CIImage) {
        setImage(image)
    }
    
    func setImage(_ image: CIImage) {
        cbsFilter.setValue(image, forKey: kCIInputImageKey)
        tempFilter.setValue(image, forKey: kCIInputImageKey)
        sharpFilter.setValue(image, forKey: kCIInputImageKey)
        clearFilter.setValue(image, forKey: kCIInputImageKey)
        blurFilter.setValue(image, forKey: kCIInputImageKey)
    }
    
    func updateImage(_ image: CIImage, by type: CorrectionType) {
        let exceptFilter = getFilter(by: type)
        [cbsFilter, tempFilter, sharpFilter, clearFilter, blurFilter].filter { $0 != exceptFilter }.forEach { filter in
            filter.setValue(image, forKey: kCIInputImageKey)
        }
    }
    
    func getFilter(by type: CorrectionType) -> CIFilter {
        switch type {
            
        case .contrast, .brightness, .saturation:
            return cbsFilter
            
        case .warmness, .coldness:
            return tempFilter
            
        case .sharpness:
            return sharpFilter
            
        case .clearness:
            return clearFilter
            
        case .blur:
            return blurFilter
        }
    }
}

// MARK: - Image Creator

final class ImageCreator {
    
    private let filters: ImageFilters
    
    init(image: CIImage) {
        filters = ImageFilters(image: image)
    }
    
    func set(image: CIImage) {
        filters.setImage(image)
    }
    
    func updateImage(image: CIImage, by type: CorrectionType) {
        filters.updateImage(image, by: type)
    }
    
    func correct(image: CIImage, by correctionType: CorrectionType, for value: Int) -> CIImage {
        let outputValue = correctionType.params.getValue(by: value)
        let correctValue: Any = {
            
            switch correctionType {
                
            case .warmness, .coldness:
                return CIVector(x: outputValue, y: 0)
                
            default:
                return outputValue
            }
        }()
        
        let filter = filters.getFilter(by: correctionType)
        
        filter.setValue(correctValue, forKey: correctionType.key)
        
        guard let outputImage = filter.outputImage, let inputImage = filter.value(forKey: kCIInputImageKey) as? CIImage else {
            return .init()
        }
        
        let cropRect = inputImage.extent
        let croppedImage = outputImage.cropped(to: cropRect)
        
        return croppedImage
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cbsFilterName: String = "CIColorControls"
    static let tempFilterName: String = "CITemperatureAndTint"
    static let sharpFilterName: String = "CISharpenLuminance"
    static let clearFilterName: String = "CIUnsharpMask"
    static let blurName: String = "CIBoxBlur"
}
