import Foundation
import AVKit

// MARK: - String Extensions

extension String {
    
    static var imageIdentifier: String {
        UTType.image.identifier
    }
    
    static var videoIdentifier: String {
        UTType.movie.identifier
    }
}
