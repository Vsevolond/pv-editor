import CoreImage

enum CIFilterType: Equatable {
    
    case composite
    case correction(type: CorrectionType)
}

// MARK: - Composite Filter

final class CompositeFilter: CIFilter {
    
    private var inputImage: CIImage?
    
    private var first: (filter: CIFilter, type: CIFilterType)?
    private var second: (filter: CIFilter, type: CIFilterType)?
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage, let firstFilter = first?.filter else { return .none }
        
        firstFilter.setValue(inputImage, forKey: kCIInputImageKey)
        guard let firstOutputImage = firstFilter.outputImage else { return inputImage }
        
        if let secondFilter = second?.filter {
            secondFilter.setValue(firstOutputImage, forKey: kCIInputImageKey)
            
            guard let secondOutputImage = secondFilter.outputImage else { return firstOutputImage }
            return secondOutputImage
            
        } else {
            return firstOutputImage
        }
    }
    
    func compose(with filter: CIFilter, type: CorrectionType) {
        if let first, let second {
            switch second.type {
                
            case .composite:
                guard let composite = second.filter as? CompositeFilter else {
                    return
                }
                composite.compose(with: filter, type: type)
                self.second?.filter = composite
                
            case .correction(let secondType):
                let composite = CompositeFilter()
                composite.compose(with: second.filter, type: secondType)
                composite.compose(with: filter, type: type)
                self.second = (composite, .composite)
                
            }
        } else if let first {
            self.second = (filter, .correction(type: type))
            
        } else {
            self.first = (filter, .correction(type: type))
        }
    }
    
    func setValue(_ value: Any, forType type: CorrectionType) {
        
        if case .correction(let firstType) = first?.type, firstType == type {
            first?.filter.setValue(value, forKey: type.key)
            
        } else if case .correction(let secondType) = second?.type, secondType == type {
            second?.filter.setValue(value, forKey: type.key)
            
        } else {
            guard let composite = second?.filter as? CompositeFilter else {
                return
            }
            
            composite.setValue(value, forType: type)
            second?.filter = composite
        }
    }
    
    override func setDefaults() {
        guard let first, case .correction(let firstType) = first.type else { return }
        let firstValue: Any = {
            let value = firstType.params.getValue(by: 0)
            switch firstType {
                
            case .warmness, .coldness:
                return CIVector(x: value, y: 0)
                
            default:
                return value
            }
        }()
        
        self.first?.filter.setValue(firstValue, forKey: firstType.key)
        
        if let secondFilter = second?.filter as? CompositeFilter {
            secondFilter.setDefaults()
            second?.filter = secondFilter
            
        } else {
            guard let second, case .correction(let secondType) = second.type else { return }
            let secondValue: Any = {
                let value = secondType.params.getValue(by: 0)
                switch firstType {
                    
                case .warmness, .coldness:
                    return CIVector(x: value, y: 0)
                    
                default:
                    return value
                }
            }()
            
            self.second?.filter.setValue(secondValue, forKey: secondType.key)
        }
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        guard key == kCIInputImageKey, let image = value as? CIImage else {
            return
        }
        
        inputImage = image
    }
}
