import CoreImage

// MARK: - Motion Blur Filter

final class MotionBlurFilter: CIFilter {
    
    var inputImage: CIImage?
    var inputBlur: CGFloat = 30
    var inputFalloff: CGFloat = 0.2
    var inputSamples: CGFloat = 10
    
    static var kernel: CIKernel = { () -> CIKernel in

        guard let kernel = CIKernel(source: Constants.source) else {
            return .init()
        }

        return kernel
    }()
    
    override var outputImage: CIImage? {
        guard let inputImage else { return nil }
        
        let args: [Any] = [inputImage,
                    CIVector(x: inputImage.extent.width, y: inputImage.extent.height),
                    inputSamples,
                    inputFalloff,
                    inputBlur]
        
        return MotionBlurFilter.kernel.apply(
            extent: inputImage.extent,
            roiCallback: { (index, rect) in
                return rect.insetBy(dx: -1, dy: -1)
            },
            arguments: args
        )
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
    kernel vec4 motionBlur(sampler image, vec2 size, float sampleCount, float start, float blur) {
        int sampleCountInt = int(floor(sampleCount));
        vec4 accumulator = vec4(0.0);
        vec2 dc = destCoord();
        float normalisedValue = length(((dc / size) - 0.5) * 2.0);
        float strength = clamp((normalisedValue - start) * (1.0 / (1.0 - start)), 0.0, 1.0);
        
        vec2 vector = normalize((dc - (size / 2.0)) / size);
        vec2 velocity = vector * strength * blur;
        
        vec2 redOffset = -vector * strength * (blur * 1.0);
        vec2 greenOffset = -vector * strength * (blur * 1.5);
        vec2 blueOffset = -vector * strength * (blur * 2.0);
        
        for (int i=0; i < sampleCountInt; i++) {
            accumulator.r += sample(image, samplerTransform(image, dc + redOffset)).r;
            redOffset -= velocity / sampleCount;
            
            accumulator.g += sample(image, samplerTransform(image, dc + greenOffset)).g;
            greenOffset -= velocity / sampleCount;
            
            accumulator.b += sample(image, samplerTransform(image, dc + blueOffset)).b;
            blueOffset -= velocity / sampleCount;
        }
        return vec4(vec3(accumulator / float(sampleCountInt)), 1.0);
    }
    """
}
