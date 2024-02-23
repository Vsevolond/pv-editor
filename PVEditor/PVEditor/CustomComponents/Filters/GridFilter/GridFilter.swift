import CoreImage

// MARK: - Grid Filter

final class GridFilter: CIFilter {
    
    var inputImage: CIImage?
    
    static var kernel: CIWarpKernel = { () -> CIWarpKernel in
          
        guard let url = Bundle.main.url(forResource: Constants.kernelFileName, withExtension: "metallib"),
              let data = try? Data(contentsOf: url)
        else {
            return .init()
        }

        guard let kernel = try? CIWarpKernel(functionName: Constants.functionName, fromMetalLibraryData: data) else {
            return .init()
        }

        return kernel
    }()

  
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else { return .none }

        return GridFilter.kernel.apply(
            extent: inputImage.extent,
            roiCallback: { _, rect in
                return rect
            }, image: inputImage,
            arguments: []
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
    
    static let kernelFileName: String = "GridKernel"
    static let functionName: String = "gridFilter"
}
