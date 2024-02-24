import UIKit

// MARK: - Filter Type

enum FilterType: CaseIterable {
    
    case original
    case sepia
    case blackWhite
    case vintage
    case negative
    case posterize
    case pixellate
    case grid
    case chromaticAbberation
    case scatter
    case motionBlur
    case colorBlur
    
    var index: Int {
        guard let index = FilterType.allCases.firstIndex(of: self) else {
            return 0
        }
        
        return index
    }
}

// MARK: - Extension

extension FilterType: EditModeProtocol {
    
    var title: String {
        return Constants.titles[index]
    }
    
    var image: UIImage? { nil }
}

// MARK: - Constants

private enum Constants {
    
    static let originalTitle: String = "ОРИГИНАЛ"
    static let sepiaTitle: String = "СЕПИЯ"
    static let blackWhiteTitle: String = "ЧЕРНО-БЕЛЫЙ"
    static let vintageTitle: String = "ВИНТАЖ"
    static let negativeTitle: String = "НЕГАТИВ"
    static let posterizeTitle: String = "ПОСТЕР"
    static let pixellateTitle: String = "ПИКСЕЛИ"
    static let gridTitle: String = "СЕТКА"
    static let chromaticAbberationTitle: String = "ХРОМАТИЧЕСКАЯ АББЕРАЦИЯ"
    static let scatterTitle: String = "РЯБЬ"
    static let motionBlurTitle: String = "АКТИВНОЕ РАЗМЫТИЕ"
    static let colorBlurTitle: String = "ЦВЕТОВОЕ РАЗМЫТИЕ"
    
    static let titles: [String] = [
        originalTitle,
        sepiaTitle,
        blackWhiteTitle,
        vintageTitle,
        negativeTitle,
        posterizeTitle,
        pixellateTitle,
        gridTitle,
        chromaticAbberationTitle,
        scatterTitle,
        motionBlurTitle,
        colorBlurTitle
    ]
}
