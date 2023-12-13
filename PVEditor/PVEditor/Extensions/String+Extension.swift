import Foundation
import AVKit

extension String {
    
    static var imageIdentifier: String {
        UTType.image.identifier
    }
    
    static var videoIdentifier: String {
        UTType.movie.identifier
    }
}
