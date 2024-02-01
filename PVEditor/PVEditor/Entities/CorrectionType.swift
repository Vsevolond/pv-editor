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
    
    static let contrastTitle: String = "Контраст"
    static let brightnessTitle: String = "Яркость"
    static let saturationTitle: String = "Насыщенность"
    static let warmnessTitle: String = "Теплота"
    static let sharpnessTitle: String = "Резкость"
    static let clearnessTitle: String = "Четкость"
    static let blurTitle: String = "Размытие"
    
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
}
