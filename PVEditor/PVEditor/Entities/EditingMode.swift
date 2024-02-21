import UIKit

// MARK: - Edit Mode Protocol

protocol EditModeProtocol {
    
    var title: String { get }
    var image: UIImage? { get }
}

// MARK: - Edit Mode

enum EditingMode: Equatable {
    
    case correction(_ type: CorrectionType)
    case filter(_ type: FilterType)
    case none
    
    var title: String {
        switch self {
            
        case .correction(let type):
            return type.title
            
        case .filter(let type):
            return type.title
            
        case .none:
            return ""
        }
    }
    
    static let titles: [String] = [Constants.correctionTitle, Constants.filterTitle]
}

// MARK: - Constants

private enum Constants {
    
    static let correctionTitle: String = "Коррекция"
    static let filterTitle: String = "Фильтры"
}
