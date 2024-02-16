import UIKit
import MetalKit
import CoreGraphics
import CoreImage

// MARK: - Image Metal View

final class ImageMetalView: MTKView {
    
    // MARK: - Private Properties
    
    private var context: CIContext?
    private var queue: MTLCommandQueue?
    private let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
    
    // MARK: - Internal Properties
    
    var image: CIImage? {
        didSet {
            drawCIImge()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: .zero, device: nil)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return
        }
        
        self.isOpaque = false
        self.device = device
        self.framebufferOnly = false
        self.isPaused = true
        self.enableSetNeedsDisplay = true
        self.context = CIContext(mtlDevice: device)
        self.queue = device.makeCommandQueue()
    }
    
    private func drawCIImge() {
        guard let image = image,
              let drawable = currentDrawable,
              let buffer = queue?.makeCommandBuffer()
        else { return }

        let drawableWidth = drawableSize.width
        let drawableHeight = drawableSize.height
        let imageWidth = image.extent.width
        let imageHeight = image.extent.height

        let widthScale = drawableWidth / imageWidth
        let heightScale = drawableHeight / imageHeight
        let scale = min(widthScale, heightScale)

        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale

        let xPosition = (drawableWidth - scaledImageWidth) / 2
        let yPosition = (drawableHeight - scaledImageHeight) / 2

        let scaledImage = image.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let translatedImage = scaledImage.transformed(by: CGAffineTransform(translationX: xPosition, y: yPosition))

        let renderingRect = CGRect(x: 0, y: 0, width: drawableWidth, height: drawableHeight)

        context?.render(translatedImage,
                       to: drawable.texture,
                       commandBuffer: buffer,
                       bounds: renderingRect,
                       colorSpace: colorSpace)
        
        buffer.present(drawable)
        buffer.commit()
        setNeedsDisplay()
    }
}

