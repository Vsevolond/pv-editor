import UIKit

// MARK: - Edit Mode Protocol

protocol EditModeProtocol {
    
    var title: String { get }
    var image: UIImage { get }
}

// MARK: - Edit Mode

enum EditingMode: Equatable {
    
    case correction(_ type: CorrectionType)
    case filter(_ type: FilterType)
    case none
}
