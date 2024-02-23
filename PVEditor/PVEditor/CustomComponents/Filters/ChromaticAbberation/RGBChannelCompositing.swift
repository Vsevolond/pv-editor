import CoreImage

// MARK: - RGB Channel Compositing

final class RGBChannelCompositing: CIFilter {
    
    var inputRedImage : CIImage?
    var inputGreenImage : CIImage?
    var inputBlueImage : CIImage?
    
    static var kernel: CIColorKernel = { () -> CIColorKernel in

        guard let kernel = CIColorKernel(source: Constants.source) else {
            return .init()
        }

        return kernel
    }()

  
    override var outputImage: CIImage? {
        guard let inputRedImage, let inputGreenImage, let inputBlueImage else {
            return .none
        }
        
        let extent = inputRedImage.extent.union(inputGreenImage.extent.union(inputBlueImage.extent))
        let arguments = [inputRedImage, inputGreenImage, inputBlueImage]
        
        return RGBChannelCompositing.kernel.apply(extent: extent, arguments: arguments)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let source: String = """
    kernel vec4 rgbChannelCompositing(__sample red, __sample green, __sample blue) {
        return vec4(red.r, green.g, blue.b, 1.0);
    }
    """
}
