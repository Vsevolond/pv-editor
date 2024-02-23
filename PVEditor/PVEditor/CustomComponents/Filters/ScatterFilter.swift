import CoreImage

// MARK: - Scatter Filter

final class ScatterFilter: CIFilter {
    
    var inputImage: CIImage?
    var inputScatterRadius: CGFloat = 25
    
    static var kernel: CIWarpKernel = { () -> CIWarpKernel in

        guard let kernel = CIWarpKernel(source: Constants.source) else {
            return .init()
        }

        return kernel
    }()
    
    override var outputImage: CIImage? {
        guard let inputImage else { return nil }
            
        return ScatterFilter.kernel.apply(
            extent: inputImage.extent,
            roiCallback: { (index, rect) in
                return rect
            },
            image: inputImage,
            arguments: [inputScatterRadius])
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        guard key == kCIInputImageKey, let image = value as? CIImage else {
            return
        }
        
        inputImage = image
    }
}

// MARK: - Constants

private enum Constants {
    
    static let source: String = """
    float noise(vec2 co) {
        vec2 seed = vec2(sin(co.x), cos(co.y));
        return fract(sin(dot(seed ,vec2(12.9898,78.233))) * 43758.5453);
    }

    kernel vec2 scatter(float radius) {
        float offsetX = radius * (-1.0 + noise(destCoord()) * 2.0);
        float offsetY = radius * (-1.0 + noise(destCoord().yx) * 2.0);
        return vec2(destCoord().x + offsetX, destCoord().y + offsetY);
    }
    """
}

