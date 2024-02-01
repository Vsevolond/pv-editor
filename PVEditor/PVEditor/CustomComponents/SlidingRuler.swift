import UIKit

// MARK: - Sliding Ruler

final class SlidingRuler: UIView {
    
    // MARK: - Internal Properties
    
    var range: ClosedRange<Int> = -100...100
    var step: Int = 10
    
    // MARK: - Private Properties
    
    private let collectionView: UICollectionView = {
        let layout = CenteredFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: Constants.cellWidth, height: .zero)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(SlidingRulerCollectionCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        return collection
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = .init(x: 0, y: bounds.midY, width: bounds.width, height: bounds.height / 2)
        addSubview(collectionView)
        
        drawCenter()
    }
    
    // MARK: - Private Methods
    
    private func drawCenter() {
        let path = UIBezierPath()
        
        let centerX = bounds.width / 2
        let centerBottomY = bounds.maxY
        let centerTopY = bounds.minY
        
        path.move(to: .init(x: centerX, y: centerBottomY))
        path.addLine(to: .init(x: centerX, y: centerTopY))
        path.close()
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = 2
        
        layer.insertSublayer(lineLayer, at: 1)
    }
    
    private func setup() {
        backgroundColor = .clear
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
}

// MARK: - Extensions

extension SlidingRuler: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        range.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? SlidingRulerCollectionCell else {
            return .init()
        }
        
        return cell
    }
}

extension SlidingRuler: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constants.cellWidth, height: collectionView.bounds.height)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cellIdentifier: String = "SlidingRulerCollectionCell"
    static let cellWidth: CGFloat = 10
}
