import UIKit
import CoreImage

// MARK: - Video Parameters

final class VideoParameters {
    
    // MARK: - Internal Properties
    
    var videoUrl: URL
    
    // MARK: - Private Properties
    
    private var correctionValues: [CorrectionType: Int]
    private var filterType: FilterType = .original
    
    // MARK: - Initializers
    
    init(videoUrl: URL) {
        self.videoUrl = videoUrl
        self.correctionValues = CorrectionType.allCases.reduce(into: [CorrectionType: Int]()) { $0[$1] = 0 }
    }
    
    // MARK: - Internal Properties
    
    func setCorrection(of type: CorrectionType, to value: Int) {
        correctionValues[type] = value
    }
    
    func setFilter(type: FilterType) {
        filterType = type
    }
    
    func getValue(of type: CorrectionType) -> Int {
        correctionValues[type] ?? 0
    }
}
