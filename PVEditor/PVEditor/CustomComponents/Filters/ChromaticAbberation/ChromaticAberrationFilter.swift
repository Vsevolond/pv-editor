import CoreImage

// MARK: - Chromatic Aberration Filter

final class ChromaticAberrationFilter: CIFilter {
    
    var inputImage: CIImage?
    
    var inputAngle: CGFloat = 0
    var inputRadius: CGFloat = 20
    
    private let tau = CGFloat(Double.pi * 2)
    
    let rgbChannelCompositing = RGBChannelCompositing()
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return nil }
        
        let redAngle = inputAngle + tau
        let greenAngle = inputAngle + tau * 0.333
        let blueAngle = inputAngle + tau * 0.666
        
        let redTransform = CGAffineTransformMakeTranslation(sin(redAngle) * inputRadius, cos(redAngle) * inputRadius)
        let greenTransform = CGAffineTransformMakeTranslation(sin(greenAngle) * inputRadius, cos(greenAngle) * inputRadius)
        let blueTransform = CGAffineTransformMakeTranslation(sin(blueAngle) * inputRadius, cos(blueAngle) * inputRadius)
        
        let red = inputImage.applyingFilter("CIAffineTransform", parameters: [kCIInputTransformKey: NSValue(cgAffineTransform: redTransform)]).cropped(to: inputImage.extent)
        
        let green = inputImage.applyingFilter("CIAffineTransform", parameters: [kCIInputTransformKey: NSValue(cgAffineTransform: greenTransform)]).cropped(to: inputImage.extent)
        
        let blue = inputImage.applyingFilter("CIAffineTransform", parameters: [kCIInputTransformKey: NSValue(cgAffineTransform: blueTransform)]).cropped(to: inputImage.extent)

        rgbChannelCompositing.inputRedImage = red
        rgbChannelCompositing.inputGreenImage = green
        rgbChannelCompositing.inputBlueImage = blue
        
        let finalImage = rgbChannelCompositing.outputImage
        
        return finalImage
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        guard key == kCIInputImageKey, let image = value as? CIImage else {
            return
        }
        
        inputImage = image
    }
}
