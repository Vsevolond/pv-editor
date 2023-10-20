import UIKit
import PhotosUI

final class FeedViewController: UIViewController {
    
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        button.setTitle("Choose Media", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.frame.size = .init(width: view.frame.width, height: 60)
        button.center = view.center
        button.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension FeedViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(results)
    }
}
