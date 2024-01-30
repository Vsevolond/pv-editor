import Foundation

// MARK: - App Color Set

enum AppColorSet {

    case darkPurple
    case amethyst
    case tropicalIndigo
    case frenchGray
    case linen
    
    var values: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        switch self {
        case .darkPurple: return (36, 32, 56)
        case .amethyst: return (144, 103, 198)
        case .tropicalIndigo: return (141, 134, 201)
        case .frenchGray: return (202, 196, 206)
        case .linen: return (247, 236, 225)
        }
    }
}
