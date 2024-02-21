import UIKit
import CoreImage

// MARK: - ImageError

enum ImageError: Error {
    
    case cannotLoad
}

// MARK: - Image Parameters

final class ImageParameters {
    
    // MARK: - Internal Properties
    
    var imageUrl: URL
    var imageWithoutFilters: CIImage
    
    var image: CIImage {
        didSet {
            updateImage?(image)
        }
    }
    
    // MARK: - Private Properties
    
    private var correctionValues: [CorrectionType: Int]
    private var filterType: FilterType = .original
    
    private let queue = DispatchQueue(label: "imageProcessing", qos: .userInteractive)
    private let imageCreator: ImageCreator
    
    private var updateImage: ((CIImage) -> Void)?
    
    // MARK: - Initializers
    
    init(imageUrl: URL) throws {
        self.imageUrl = imageUrl
        if let data = try? Data(contentsOf: imageUrl),
           let uiImage = UIImage(data: data),
           let ciImage = CIImage(image: uiImage)
        {
            self.imageUrl = imageUrl
            self.image = ciImage.oriented(forExifOrientation: Int32(uiImage.cgImagePropertyOrientation.rawValue))
            self.imageWithoutFilters = image

        } else {
            throw ImageError.cannotLoad
        }
        
        self.correctionValues = CorrectionType.allCases.reduce(into: [CorrectionType: Int]()) { $0[$1] = 0 }
        self.imageCreator = .init(image: image)
    }
    
    // MARK: - Internal Properties
    
    func setCorrection(of type: CorrectionType, to value: Int) {
        correctionValues[type] = value
        
        queue.async { [weak self] in
            guard let self else { return }
            let (filteredImage, newImage) = imageCreator.correct(image: imageWithoutFilters, by: (type, filterType), for: value)
            image = filteredImage
            imageWithoutFilters = newImage
        }
    }
    
    func setFilter(type: FilterType) {
        filterType = type
        
        queue.async { [weak self] in
            guard let self else { return }
            let newImage = imageCreator.filter(image: imageWithoutFilters, by: type)
            image = newImage
        }
    }
    
    func getValue(of type: CorrectionType) -> Int {
        correctionValues[type] ?? 0
    }
    
    func onImageChange(_ handler: @escaping (CIImage) -> Void) {
        updateImage = handler
    }
    
    func updateFiltersImage(by type: CorrectionType) {
        imageCreator.updateImage(image: imageWithoutFilters, by: type)
    }
}
