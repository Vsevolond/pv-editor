import UIKit
import PhotosUI

final class FeedViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.minimumLineSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(FeedModeCollectionCell.self, forCellWithReuseIdentifier: Constants.modeCellIdentifier)
        collection.register(FeedCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: Constants.headerIdentifier)
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    // MARK: - Internal Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupGradient()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        layout()
    }

    // MARK: - Private Methods

    private func setup() {
        setupCollectionView()
    }
    
    private func layout() {
        collectionView.frame = .init(x: 0, y: view.safeAreaInsets.top, width: view.bounds.width, 
                                     height: view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        view.addSubview(collectionView)
    }
    
    private func setupGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = Constants.gradient
        layer.startPoint = .init(x: 0.2, y: 0.2)
        layer.endPoint = .init(x: 0.8, y: 0.8)
        
        let animation = CABasicAnimation(keyPath: Constants.animationName)
        animation.fromValue = Constants.gradient
        animation.toValue = Array(Constants.gradient.reversed())
        animation.duration = 10.0
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.speed = 0.8
        
        layer.add(animation, forKey: nil)
        view.layer.addSublayer(layer)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Private Extensions

extension FeedViewController {

    private func openGallery(for type: FeedCellType) {
        var configuration = PHPickerConfiguration()
        configuration.filter = type.filter
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openImageEditor(with imageUrl: URL) {
        let imageEditorViewController = ImageEditorViewController(imageUrl: imageUrl)
        imageEditorViewController.modalTransitionStyle = .crossDissolve
        imageEditorViewController.modalPresentationStyle = .fullScreen
        present(imageEditorViewController, animated: true)
    }
    
    private func openVideoEditor(with videoUrl: URL) {
        let videoEditorViewController = VideoEditorViewController(videoUrl: videoUrl)
        videoEditorViewController.modalTransitionStyle = .crossDissolve
        videoEditorViewController.modalPresentationStyle = .fullScreen
        present(videoEditorViewController, animated: true)
    }
}

// MARK: - Protocol Extensions

extension FeedViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else {
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(.imageIdentifier) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: .imageIdentifier) { imageUrl, error in
                guard let imageUrl else {
                    return
                }
                
                let tempUrl = FileManager.default.copyFile(at: imageUrl)
                
                DispatchQueue.main.async {
                    self.openImageEditor(with: tempUrl)
                }
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier(.videoIdentifier) {
            itemProvider.loadFileRepresentation(forTypeIdentifier: .videoIdentifier) { videoUrl, error in
                guard let videoUrl else {
                    return
                }
                
                let tempUrl = FileManager.default.copyFile(at: videoUrl)

                DispatchQueue.main.async {
                    self.openVideoEditor(with: tempUrl)
                }
            }
        }
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.modeCellIdentifier,
                                                            for: indexPath) as? FeedModeCollectionCell
        else {
            return .init()
        }
        
        let type: FeedCellType = FeedCellType.allCases[indexPath.row]
        cell.configure(with: type)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, 
                        at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard kind == UICollectionView.elementKindSectionHeader,
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerIdentifier, 
                                                                               for: indexPath) as? FeedCollectionHeaderView
        else {
            return .init()
        }
        
        headerView.setTitle(Constants.appName)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = FeedCellType.allCases[indexPath.row]
        openGallery(for: type)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, 
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return .init(width: collectionView.bounds.width - 20, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return .init(width: .zero, height: 80)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let gradient: [CGColor] = [
        UIColor.appColor(.amethyst).cgColor,
        UIColor.black.cgColor
    ]
    
    static let animationName: String = "colors"
    
    static let appName: String = "PVEditor"
    
    static let modeCellIdentifier: String = "FeedModeCollectionCell"
    static let headerIdentifier: String = "FeedCollectionHeaderView"
}
