import UIKit

// MARK: - ImageEditorViewController

final class ImageEditorViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let imageView = UIImageView()
    private let imageUrl: URL
    
    // MARK: - Initializers
    
    init(imageUrl: URL) {
        if let data = try? Data(contentsOf: imageUrl),
           let image = UIImage(data: data)
        {
            self.imageUrl = imageUrl
            self.imageView.image = image

        } else {
            fatalError("can't load image")
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        try? FileManager.default.removeItem(at: imageUrl)
    }
    
    // MARK: - Internal Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = .white
        
        configureImageView()
        view.addSubview(imageView)
    }
    
    private func configureImageView() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
    }
}
