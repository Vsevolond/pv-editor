import UIKit

final class ImageEditorViewController: UIViewController {
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
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
