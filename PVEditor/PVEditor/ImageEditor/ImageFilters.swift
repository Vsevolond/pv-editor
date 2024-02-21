import UIKit

// MARK: - Image Filters

final class ImageFilters {
    
    // MARK: - Private Properties
    
    private let cbsFilter: CIFilter = .init(name: Constants.cbsFilterName)!
    private let tempFilter: CIFilter = .init(name: Constants.tempFilterName)!
    private let sharpFilter: CIFilter = .init(name: Constants.sharpFilterName)!
    private let clearFilter: CIFilter = .init(name: Constants.clearFilterName)!
    private let blurFilter: CIFilter = .init(name: Constants.blurName)!
    
    private let sepiaFilter: CIFilter = .init(name: Constants.sepiaName)!
    private let blackWhiteFilter: CIFilter = .init(name: Constants.blackWhiteName)!
    private let vintageFilter: CIFilter = .init(name: Constants.vintageName)!
    private let negativeFilter: CIFilter = .init(name: Constants.negativeFilter)!
    
    init(image: CIImage) {
        setImage(image)
    }
    
    func setImage(_ image: CIImage) {
        cbsFilter.setValue(image, forKey: kCIInputImageKey)
        tempFilter.setValue(image, forKey: kCIInputImageKey)
        sharpFilter.setValue(image, forKey: kCIInputImageKey)
        clearFilter.setValue(image, forKey: kCIInputImageKey)
        blurFilter.setValue(image, forKey: kCIInputImageKey)
        
        sepiaFilter.setValue(image, forKey: kCIInputImageKey)
        blackWhiteFilter.setValue(image, forKey: kCIInputImageKey)
        vintageFilter.setValue(image, forKey: kCIInputImageKey)
        negativeFilter.setValue(image, forKey: kCIInputImageKey)
    }
    
    func updateImage(_ image: CIImage, by type: CorrectionType) {
        let exceptFilter = getFilter(by: type)
        [cbsFilter, tempFilter, sharpFilter, clearFilter, blurFilter].filter { $0 != exceptFilter }.forEach { filter in
            filter.setValue(image, forKey: kCIInputImageKey)
        }
        
        [sepiaFilter, blackWhiteFilter, vintageFilter, negativeFilter].forEach { filter in
            filter.setValue(image, forKey: kCIInputImageKey)
        }
    }
    
    func getFilter(by type: CorrectionType) -> CIFilter {
        switch type {
            
        case .contrast, .brightness, .saturation: return cbsFilter
            
        case .warmness, .coldness: return tempFilter
            
        case .sharpness: return sharpFilter
            
        case .clearness: return clearFilter
            
        case .blur: return blurFilter
        }
    }
    
    func getFilter(by type: FilterType) -> CIFilter? {
        switch type {
            
        case .original: return nil
            
        case .sepia: return sepiaFilter
            
        case .blackWhite: return blackWhiteFilter
            
        case .vintage: return vintageFilter
            
        case .negative: return negativeFilter
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cbsFilterName: String = "CIColorControls"
    static let tempFilterName: String = "CITemperatureAndTint"
    static let sharpFilterName: String = "CISharpenLuminance"
    static let clearFilterName: String = "CIUnsharpMask"
    static let blurName: String = "CIBoxBlur"
    
    static let sepiaName: String = "CISepiaTone"
    static let blackWhiteName: String = "CIPhotoEffectTonal"
    static let vintageName: String = "CIPhotoEffectTransfer"
    static let negativeFilter: String = "CIColorInvert"
}
