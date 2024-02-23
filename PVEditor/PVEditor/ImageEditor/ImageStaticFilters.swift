import CoreImage

// MARK: - Image Static Filters

struct ImageStaticFilters {
    
    static let sepiaFilter: CIFilter = .init(name: Constants.sepiaName)!
    static let blackWhiteFilter: CIFilter = .init(name: Constants.blackWhiteName)!
    static let vintageFilter: CIFilter = .init(name: Constants.vintageName)!
    static let negativeFilter: CIFilter = .init(name: Constants.negativeFilterName)!
    static let posterizeFilter: CIFilter = .init(name: Constants.posterizeFilterName)!
    static let gridFilter: GridFilter = GridFilter()
    static let chromaticAbberationFilter: ChromaticAberrationFilter = ChromaticAberrationFilter()
    static let scatterFilter: ScatterFilter = ScatterFilter()
    static let motionBlurFilter: MotionBlurFilter = MotionBlurFilter()
    static let colorBlurFilter: ColorBlurFilter = ColorBlurFilter()
    
    static var images: [FilterType: CIImage] = [:]
    private static let queue: DispatchQueue = .init(label: "imageFiltering", qos: .background, attributes: .concurrent)
    private static let lock = NSLock()
    
    static func getFilter(by type: FilterType) -> CIFilter? {
        switch type {
        case .original: return nil
        case .sepia: return sepiaFilter
        case .blackWhite: return blackWhiteFilter
        case .vintage: return vintageFilter
        case .negative: return negativeFilter
        case .posterize: return posterizeFilter
        case .grid: return gridFilter
        case .chromaticAbberation: return chromaticAbberationFilter
        case .scatter: return scatterFilter
        case .motionBlur: return motionBlurFilter
        case .colorBlur: return colorBlurFilter
        }
    }
    
    static func setImage(_ image: CIImage) {
        [sepiaFilter, blackWhiteFilter, vintageFilter, negativeFilter, posterizeFilter, gridFilter, 
         chromaticAbberationFilter, scatterFilter, motionBlurFilter, colorBlurFilter]
        .forEach { filter in
            filter.setValue(image, forKey: kCIInputImageKey)
        }
        
        updateImages(by: image)
    }
    
    static func getImage(by type: FilterType) -> CIImage { images[type] ?? .init() }
    
    private static func updateImages(by image: CIImage) {
        for type in FilterType.allCases {
            queue.async {
                lock.lock()
                defer { lock.unlock() }
                
                guard let filter = getFilter(by: type), let outputImage = filter.outputImage else {
                    images.updateValue(image, forKey: type)
                    return
                }
                images.updateValue(outputImage, forKey: type)
            }
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let sepiaName: String = "CISepiaTone"
    static let blackWhiteName: String = "CIPhotoEffectTonal"
    static let vintageName: String = "CIPhotoEffectTransfer"
    static let negativeFilterName: String = "CIColorInvert"
    static let posterizeFilterName: String = "CIColorPosterize"
}
