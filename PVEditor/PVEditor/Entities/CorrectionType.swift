import UIKit

// MARK: - Correction Type

enum CorrectionType: CaseIterable {
    
    case contrast
    case brightness
    case saturation
    case warmness
    case coldness
    case sharpness
    case clearness
    case blur
    
    var index: Int {
        guard let index = CorrectionType.allCases.firstIndex(of: self) else {
            return 0
        }
        
        return index
    }
    
    var key: String {
        return Constants.keys[index]
    }
    
    var params: CorrectionParameters {
        return Constants.parameters[index]
    }
    
    var range: ClosedRange<Int> {
        switch self {
            
        case .contrast, .brightness, .saturation:
            return Constants.fullRange
            
        case .warmness, .coldness, .sharpness, .clearness, .blur:
            return Constants.halfRange
        }
    }
}

// MARK: - Extension

extension CorrectionType: EditModeProtocol {
    
    var title: String {
        return Constants.titles[index]
    }
    
    var image: UIImage {
        guard let image = Constants.images[index] else {
            return .init()
        }
        
        return image
    }
}

// MARK: - Constants

private enum Constants {
    
    static let contrastTitle: String = "КОНТРАСТ"
    static let brightnessTitle: String = "ЯРКОСТЬ"
    static let saturationTitle: String = "НАСЫЩЕННОСТЬ"
    static let warmnessTitle: String = "ТЕПЛОТА"
    static let coldnessTitle: String = "ХОЛОД"
    static let sharpnessTitle: String = "РЕЗКОСТЬ"
    static let clearnessTitle: String = "ЧЕТКОСТЬ"
    static let blurTitle: String = "РАЗМЫТИЕ"
    
    static let titles: [String] = [
        contrastTitle,
        brightnessTitle,
        saturationTitle,
        warmnessTitle,
        coldnessTitle,
        sharpnessTitle,
        clearnessTitle,
        blurTitle
    ]
    
    static var contrastImage: UIImage? = UIImage(systemName: "circle.righthalf.filled")
    static let brightnessImage: UIImage? = UIImage(systemName: "sun.min.fill")
    static let saturationImage: UIImage? = UIImage(systemName: "rainbow")
    static let warmnessImage: UIImage? = UIImage(systemName: "thermometer.sun")
    static let coldnessImage: UIImage? = UIImage(systemName: "thermometer.snowflake")
    static let sharpnessImage: UIImage? = UIImage(systemName: "righttriangle.fill")
    static let clearnessImage: UIImage? = UIImage(systemName: "righttriangle.split.diagonal")
    static let blurImage: UIImage? = UIImage(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal")
    
    static let images: [UIImage?] = [
        contrastImage,
        brightnessImage,
        saturationImage,
        warmnessImage,
        coldnessImage,
        sharpnessImage,
        clearnessImage,
        blurImage
    ]
    
    static let fullRange: ClosedRange<Int> = -100...100
    static let halfRange: ClosedRange<Int> = 0...100
    
    static let contrastKey: String = kCIInputContrastKey
    static let brightnessKey: String = kCIInputBrightnessKey
    static let saturationKey: String = kCIInputSaturationKey
    static let warmnessKey: String = "inputTargetNeutral"
    static let coldnessKey: String = "inputNeutral"
    static let sharpnessKey: String = kCIInputSharpnessKey
    static let clearnessKey: String = kCIInputIntensityKey
    static let blurKey: String = kCIInputRadiusKey
    
    static let keys: [String] = [
        contrastKey,
        brightnessKey,
        saturationKey,
        warmnessKey,
        coldnessKey,
        sharpnessKey,
        clearnessKey,
        blurKey
    ]
    
    static let contrastParams: CorrectionParameters = .init(min: 0.25, max: 2, default: 1)
    static let brightnessParams: CorrectionParameters = .init(min: -1, max: 1, default: 0)
    static let saturationParams: CorrectionParameters = .init(min: 0, max: 2, default: 1)
    static let warmnessParams: CorrectionParameters = .init(min: 6500, max: 3000, default: 6500)
    static let coldnessParams: CorrectionParameters = .init(min: 6500, max: 3000, default: 6500)
    static let sharpnessParams: CorrectionParameters = .init(min: 0.4, max: 1, default: 0.4)
    static let clearnessParams: CorrectionParameters = .init(min: 0.5, max: 1, default: 0.5)
    static let blurParams: CorrectionParameters = .init(min: 0, max: 100, default: 0)
    
    static let parameters: [CorrectionParameters] = [
        contrastParams,
        brightnessParams,
        saturationParams,
        warmnessParams,
        coldnessParams,
        sharpnessParams,
        clearnessParams,
        blurParams
    ]
}
