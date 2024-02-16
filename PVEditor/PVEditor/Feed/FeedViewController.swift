import UIKit
import PhotosUI

final class FeedViewController: UIViewController {
    
    // MARK: - Private Properties

    private let titleLabel: UILabel = UILabel()
    private let stackView: UIStackView = UIStackView()
    private var videoButton: UIButton = UIButton()
    private var photoButton: UIButton = UIButton()
    private var convertButton: UIButton = UIButton()
    
    // MARK: - Internal Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
    }

    // MARK: - Private Methods

    private func setup() {
        setupGradient()
        setupTitle()
        setupStackView()
        setupButton(type: .video, button: &videoButton)
        setupButton(type: .photo, button: &photoButton)
        setupButton(type: .convert, button: &convertButton)
    }
    
    private func layout() {
        titleLabel.frame = .init(x: 10, y: view.safeAreaInsets.top, width: view.bounds.width, height: 40)
        view.addSubview(titleLabel)
        
        stackView.frame.size = .init(width: view.bounds.width - 40, height: Constants.height)
        stackView.center = view.center
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(videoButton)
        stackView.addArrangedSubview(photoButton)
        stackView.addArrangedSubview(convertButton)
    }
    
    private func setupGradient() {
        let layer = CAGradientLayer()
        layer.frame = view.bounds
        layer.colors = Constants.gradient
        view.layer.addSublayer(layer)
    }
    
    private func setupTitle() {
        titleLabel.font = .boldSystemFont(ofSize: 40)
        titleLabel.textColor = .white
        titleLabel.text = Constants.appName
        titleLabel.textAlignment = .left
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layer.cornerRadius = Constants.cornerRadius
        stackView.layer.shadowColor = Constants.shadowColor
        stackView.layer.shadowOpacity = Constants.shadowOpacity
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowRadius = Constants.shadowRadius
        stackView.layer.shouldRasterize = true
        stackView.layer.rasterizationScale = UIScreen.main.scale
        stackView.backgroundColor = Constants.stackColor
    }
    
    private func setupButton(type: FeedButtonType, button: inout UIButton) {
        var configuration = UIButton.Configuration.plain()
        configuration.title = type.title
        configuration.image = type.image
        configuration.imagePlacement = .top
        configuration.imagePadding = Constants.imagePadding
        configuration.titleTextAttributesTransformer = .init({ attributes in
            var newAttributes = attributes
            newAttributes.font = Constants.buttonFont
            return newAttributes
        })
        button.configuration = configuration
        button.tintColor = type.tintColor
        button.backgroundColor = type.backgroundColor
        button.layer.cornerRadius = Constants.cornerRadius
        switch type {
        case .video:
            button.addAnimateAction(effect: .bounce.up, for: .touchUpInside) {
                self.openGallery(for: .videos)
            }
        case .photo:
            button.addAnimateAction(effect: .bounce.up, for: .touchUpInside) {
                self.openGallery(for: .images)
            }
        case .convert:
            button.addAnimateAction(effect: .bounce.up, for: .touchUpInside) {
                self.openGallery(for: .any(of: [.videos, .images]))
            }
        }
    }
}

// MARK: - Private Extensions

extension FeedViewController {

    private func openGallery(for filter: PHPickerFilter) {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
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

// MARK: - Constants

private enum Constants {
    
    // MARK: - View
    
    static let gradient: [CGColor] = [
        UIColor.appColor(.amethyst).cgColor,
        UIColor.black.cgColor
    ]
    
    // MARK: - Stack

    static let height: CGFloat = 200
    static let cornerRadius: CGFloat = 20
    static let shadowOpacity: Float = 0.7
    static let shadowRadius: CGFloat = 25
    static let shadowColor: CGColor = UIColor.white.cgColor
    static let stackColor: UIColor = .clear
    
    // MARK: - Button

    static let imagePadding: CGFloat = 10
    static let buttonFont: UIFont = .boldSystemFont(ofSize: 20)
    
    // MARK: - Navigation Title
    
    static let appName: String = "PVEditor"
}
