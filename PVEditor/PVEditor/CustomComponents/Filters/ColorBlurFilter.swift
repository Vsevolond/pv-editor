import CoreImage

// MARK: - Color Blur Filter

final class ColorBlurFilter: CIFilter {
    
    var inputImage: CIImage?
    var inputThreshold: CGFloat = 0.5
    var inputRadius: CGFloat = 15
    
    static var kernel: CIKernel = { () -> CIKernel in

        guard let kernel = CIKernel(source: Constants.source) else {
            return .init()
        }

        return kernel
    }()
    
    override var outputImage: CIImage? {
        guard let inputImage else {
            return nil
        }
        
        return ColorBlurFilter.kernel.apply(extent: inputImage.extent, roiCallback: { (index, rect) in
            return rect
        }, arguments: [inputImage, inputRadius, inputThreshold])
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
    kernel vec4 colorDirectedBlurKernel(sampler image, float radius, float threshold) {
        int r = int(radius);
        float n = 0.0;
        vec2 d = destCoord();
        vec3 thisPixel = sample(image, samplerCoord(image)).rgb;
        
        vec3 nwAccumulator = vec3(0.0, 0.0, 0.0);
        vec3 neAccumulator = vec3(0.0, 0.0, 0.0);
        vec3 swAccumulator = vec3(0.0, 0.0, 0.0);
        vec3 seAccumulator = vec3(0.0, 0.0, 0.0);
        
        for (int x = 0; x <= r; x++) {
            for (int y = 0; y <= r; y++) {
    
                nwAccumulator += sample(image, samplerTransform(image, d + vec2(-x ,-y))).rgb;
                neAccumulator += sample(image, samplerTransform(image, d + vec2(x ,-y))).rgb;
                swAccumulator += sample(image, samplerTransform(image, d + vec2(-x ,y))).rgb;
                seAccumulator += sample(image, samplerTransform(image, d + vec2(x ,y))).rgb;
                n = n + 1.0;
            }
        }
        
        nwAccumulator /= n;
        neAccumulator /= n;
        swAccumulator /= n;
        seAccumulator /= n;
        
        float nwDiff = distance(thisPixel, nwAccumulator);
        float neDiff = distance(thisPixel, neAccumulator);
        float swDiff = distance(thisPixel, swAccumulator);
        float seDiff = distance(thisPixel, seAccumulator);

        if (nwDiff >= threshold && neDiff >= threshold && swDiff >= threshold && seDiff >= threshold) {
            return vec4(thisPixel, 1.0);
        }
        
        if (nwDiff < neDiff && nwDiff < swDiff && nwDiff < seDiff) {
            return vec4(nwAccumulator, 1.0);
        }
        
        if (neDiff < nwDiff && neDiff < swDiff && neDiff < seDiff) {
            return vec4(neAccumulator, 1.0);
        }
        
        if (swDiff < nwDiff && swDiff < neDiff && swDiff < seDiff) {
            return vec4(swAccumulator, 1.0);
        }
        
        if (seDiff < nwDiff && seDiff < neDiff && seDiff < swDiff) {
            return vec4(seAccumulator, 1.0);
        }
        
        return vec4(thisPixel, 1.0);
    }
    """
}
