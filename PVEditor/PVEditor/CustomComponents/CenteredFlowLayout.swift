import UIKit

// MARK: - Thumbnail Flow Layout

final class CenteredFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Private Properties
    
    private let minimumSnapVelocity: CGFloat = 0.3
    
    // MARK: - Internal Properties
    
    var itemsCount: Int {
        collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var farInset: CGFloat {
        guard let collectionView else { return .zero }
        
        return (collectionView.bounds.width - itemSize.width) / 2
    }
    
    var insets: UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: farInset, bottom: .zero, right: farInset)
    }
    
    // MARK: - Internal Methods
    
    override func prepare() {
        collectionView?.contentInset = insets
        super.prepare()
    }
    
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        var offsetAdjusment = CGFloat.greatestFiniteMagnitude
        let horizontalPosition: CGFloat

        horizontalPosition = proposedContentOffset.x + (collectionView.bounds.width * 0.5)

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        layoutAttributesArray?.forEach { layoutAttributes in
            
            let itemHorizontalPosition: CGFloat
            itemHorizontalPosition = layoutAttributes.center.x

            if abs(itemHorizontalPosition - horizontalPosition) < abs(offsetAdjusment) {

                if abs(velocity.x) < self.minimumSnapVelocity {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition
                    
                } else if velocity.x > 0 {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition + (layoutAttributes.bounds.width + self.minimumLineSpacing)
                    
                } else {
                    offsetAdjusment = itemHorizontalPosition - horizontalPosition - (layoutAttributes.bounds.width + self.minimumLineSpacing)
                }
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjusment, y: proposedContentOffset.y)
    }
}
