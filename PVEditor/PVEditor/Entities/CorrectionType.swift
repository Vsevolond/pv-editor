import UIKit

// MARK: - Correction Type

enum CorrectionType: CaseIterable {
    
    case contrast
    case brightness
    case saturation
    case warmness
    case sharpness
    case clearness
    case blur
    
    var range: ClosedRange<Int> {
        switch self {
            
        case .contrast, .brightness, .saturation, .warmness:
            return Constants.fullRange
            
        case .sharpness, .clearness, .blur:
            return Constants.halfRange
        }
    }
}

// MARK: - Extension

extension CorrectionType: EditModeProtocol {
    
    var title: String {
        guard let index = CorrectionType.allCases.firstIndex(of: self) else {
            return ""
        }
        
        return Constants.titles[index]
    }
    
    var image: UIImage {
        guard 
            let index = CorrectionType.allCases.firstIndex(of: self),
            let image = Constants.images[index]
        else {
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
    static let sharpnessTitle: String = "РЕЗКОСТЬ"
    static let clearnessTitle: String = "ЧЕТКОСТЬ"
    static let blurTitle: String = "РАЗМЫТИЕ"
    
    static let titles: [String] = [
        contrastTitle,
        brightnessTitle,
        saturationTitle,
        warmnessTitle,
        sharpnessTitle,
        clearnessTitle,
        blurTitle
    ]
    
    static var contrastImage: UIImage? = UIImage(systemName: "circle.righthalf.filled")
    static let brightnessImage: UIImage? = UIImage(systemName: "sun.min.fill")
    static let saturationImage: UIImage? = UIImage(systemName: "rainbow")
    static let warmnessImage: UIImage? = UIImage(systemName: "thermometer.medium")
    static let sharpnessImage: UIImage? = UIImage(systemName: "righttriangle.fill")
    static let clearnessImage: UIImage? = UIImage(systemName: "righttriangle.split.diagonal")
    static let blurImage: UIImage? = UIImage(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal")
    
    static let images: [UIImage?] = [
        contrastImage,
        brightnessImage,
        saturationImage,
        warmnessImage,
        sharpnessImage,
        clearnessImage,
        blurImage
    ]
    
    static let fullRange: ClosedRange<Int> = -100...100
    static let halfRange: ClosedRange<Int> = 0...100
}
