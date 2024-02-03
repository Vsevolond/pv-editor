import UIKit

// MARK: - Sliding Ruler Collection Cell

final class SlidingRulerCollectionCell: UICollectionViewCell {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let centerX = bounds.width / 2
        let centerBottomY = bounds.maxY
        let centerTopY = bounds.minY
        
        path.move(to: .init(x: centerX, y: centerBottomY))
        path.addLine(to: .init(x: centerX, y: centerTopY))
        path.close()
        
        UIColor.darkGray.set()
        path.lineWidth = 2
        path.stroke()
    }
}
