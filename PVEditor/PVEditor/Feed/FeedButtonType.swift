import UIKit

enum FeedButtonType {
    
    case video
    case photo
    case convert
    
    var title: String {
        switch self {
        case .video: return Constants.video
        case .photo: return Constants.photo
        case .convert: return Constants.convert
        }
    }
    
    var image: UIImage {
        switch self {
        case .video: return Constants.videoIcon
        case .photo: return Constants.photoIcon
        case .convert: return Constants.convertIcon
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .video: return Constants.videoBackgroundColor
        case .photo: return Constants.photoBackgroundColor
        case .convert: return Constants.convertBackgroundColor
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .video: return Constants.videoTintColor
        case .photo: return Constants.photoTintColor
        case .convert: return Constants.convertTintColor
        }
    }
}

private enum Constants {
    
    static let video: String = "Video"
    static let photo: String = "Photo"
    static let convert: String = "Convert"
    
    static let videoBackgroundColor: UIColor = .appColor(.darkPurple)
    static let photoBackgroundColor: UIColor = .appColor(.amethyst)
    static let convertBackgroundColor: UIColor = .appColor(.frenchGray)
    
    static let videoTintColor: UIColor = .appColor(.frenchGray)
    static let photoTintColor: UIColor = .appColor(.linen)
    static let convertTintColor: UIColor = .appColor(.darkPurple)
    
    static var videoIcon: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        return UIImage(systemName: "movieclapper", withConfiguration: config)!
    }

    static var photoIcon: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        return UIImage(systemName: "photo", withConfiguration: config)!
    }

    static var convertIcon: UIImage {
        let config = UIImage.SymbolConfiguration(pointSize: 32)
        return UIImage(systemName: "arrow.2.squarepath", withConfiguration: config)!
    }
}
