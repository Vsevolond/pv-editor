import CoreImage

// MARK: - Image Adjust Filters

struct ImageAdjustFilters {
    
    static let contrastFilter: CIFilter = .init(name: Constants.contrastFilterName)!
    static let brightnessFilter: CIFilter = .init(name: Constants.brightnessFilterName)!
    static let saturationFilter: CIFilter = .init(name: Constants.saturationFilterName)!
    static let tempFilter: CIFilter = .init(name: Constants.tempFilterName)!
    static let sharpFilter: CIFilter = .init(name: Constants.sharpFilterName)!
    static let clearFilter: CIFilter = .init(name: Constants.clearFilterName)!
    static let blurFilter: CIFilter = .init(name: Constants.blurName)!
    
    static func getFilter(by type: CorrectionType) -> CIFilter {
        switch type {
        case .contrast: return contrastFilter
        case .brightness: return brightnessFilter
        case .saturation: return saturationFilter
        case .warmness, .coldness: return tempFilter
        case .sharpness: return sharpFilter
        case .clearness: return clearFilter
        case .blur: return blurFilter
        }
    }
    
    static func setImage(_ image: CIImage) {
        contrastFilter.setValue(image, forKey: kCIInputImageKey)
        brightnessFilter.setValue(image, forKey: kCIInputImageKey)
        saturationFilter.setValue(image, forKey: kCIInputImageKey)
        tempFilter.setValue(image, forKey: kCIInputImageKey)
        sharpFilter.setValue(image, forKey: kCIInputImageKey)
        clearFilter.setValue(image, forKey: kCIInputImageKey)
        blurFilter.setValue(image, forKey: kCIInputImageKey)
    }
    
    static func updateImage(_ image: CIImage, by type: CorrectionType) {
        let exceptFilter = getFilter(by: type)
        [contrastFilter, brightnessFilter, saturationFilter, tempFilter, sharpFilter, clearFilter, blurFilter]
        .filter { $0 != exceptFilter }.forEach { filter in
            
            filter.setValue(image, forKey: kCIInputImageKey)
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let contrastFilterName: String = "CIColorControls"
    static let brightnessFilterName: String = "CIExposureAdjust"
    static let saturationFilterName: String = "CIVibrance"
    static let tempFilterName: String = "CITemperatureAndTint"
    static let sharpFilterName: String = "CISharpenLuminance"
    static let clearFilterName: String = "CIUnsharpMask"
    static let blurName: String = "CIBoxBlur"
}
