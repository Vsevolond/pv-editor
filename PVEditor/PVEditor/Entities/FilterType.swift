import UIKit

// MARK: - Filter Type

enum FilterType: CaseIterable {
    
    case sepia
    case blackWhite
    case vintage
    case negative
}

// MARK: - Extension

extension FilterType: EditModeProtocol {
    
    var title: String {
        guard let index = FilterType.allCases.firstIndex(of: self) else {
            return ""
        }
        
        return Constants.titles[index]
    }
    
    var image: UIImage {
        guard
            let index = FilterType.allCases.firstIndex(of: self),
            let image = Constants.images[index]
        else {
            return .init()
        }
        
        return image
    }
}

// MARK: - Constants

private enum Constants {
    
    static let sepiaTitle: String = "Сепия"
    static let blackWhiteTitle: String = "Черно-белый"
    static let vintageTitle: String = "Винтаж"
    static let negativeTitle: String = "Негатив"
    
    static let titles: [String] = [
        sepiaTitle,
        blackWhiteTitle,
        vintageTitle,
        negativeTitle
    ]
    
    static let sepiaImage: UIImage? = UIImage(named: "sepia")
    static let blackWhiteImage: UIImage? = UIImage(named: "black-white")
    static let vintageImage: UIImage? = UIImage(named: "vintage")
    static let negativeImage: UIImage? = UIImage(named: "negative")
    
    static let images: [UIImage?] = [
        sepiaImage,
        blackWhiteImage,
        vintageImage,
        negativeImage
    ]
}
