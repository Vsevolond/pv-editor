import UIKit

// MARK: - Filter Type

enum FilterType: CaseIterable {
    
    case original
    case sepia
    case blackWhite
    case vintage
    case negative
    
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
    
    static let titles: [String] = [
        originalTitle,
        sepiaTitle,
        blackWhiteTitle,
        vintageTitle,
        negativeTitle
    ]
}
