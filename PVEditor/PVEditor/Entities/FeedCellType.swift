import UIKit
import PhotosUI

enum FeedCellType: CaseIterable {
    
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
    
    var filter: PHPickerFilter {
        switch self {
        case .video: return .videos
        case .photo: return .images
        case .convert: return .any(of: [.videos, .images])
        }
    }
}

private enum Constants {
    
    static let video: String = "Видео редактор"
    static let photo: String = "Фото редактор"
    static let convert: String = "Преобразовать"
    
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
