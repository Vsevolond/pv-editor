import UIKit

extension UIColor {
    
    static func appColor(_ type: AppColorSet) -> UIColor {
        let values = type.values
        let red: CGFloat = values.red / 255
        let green: CGFloat = values.green / 255
        let blue: CGFloat = values.blue / 255
        
        return .init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    static func + (left: UIColor, right: UIColor) -> UIColor {
        var (leftRed, leftGreen, leftBlue, leftAlpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (rightRed, rightGreen, rightBlue, rightAlpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        left.getRed(&leftRed, green: &leftGreen, blue: &leftBlue, alpha: &leftAlpha)
        right.getRed(&rightRed, green: &rightGreen, blue: &rightBlue, alpha: &rightAlpha)

        return UIColor(
            red: (leftRed + rightRed) / 2,
            green: (leftGreen + rightGreen) / 2,
            blue: (leftBlue + rightBlue) / 2,
            alpha: (leftAlpha + rightAlpha) / 2
        )
    }
}

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
