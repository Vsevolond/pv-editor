import UIKit

// MARK: - ImageError

enum ImageError: Error {
    
    case cannotLoad
}

// MARK: - Image Parameters

struct ImageParameters {
    
    // MARK: - Internal Properties
    
    var image: UIImage
    var imageUrl: URL
    
    // MARK: - Private Properties
    
    private var correction: [CorrectionType: Int]
    private var filter: FilterType? = nil
    
    // MARK: - Initializers
    
    init(imageUrl: URL) throws {
        self.imageUrl = imageUrl
        if let data = try? Data(contentsOf: imageUrl),
           let image = UIImage(data: data)
        {
            self.imageUrl = imageUrl
            self.image = image

        } else {
            throw ImageError.cannotLoad
        }
        
        self.correction = CorrectionType.allCases.reduce(into: [CorrectionType: Int]()) { $0[$1] = 0 }
    }
    
    // MARK: - Internal Properties
    
    mutating func setCorrection(of type: CorrectionType, to value: Int) {
        correction[type] = value
    }
    
    mutating func setFilter(type: FilterType) {
        self.filter = type
    }
    
    func getValue(of type: CorrectionType) -> Int {
        correction[type] ?? 0
    }
}
