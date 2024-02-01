import UIKit

// MARK: - ImageEditorViewController

final class ImageEditorViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let model: ImageEditorModel = ImageEditorModel()
    
    private let imageView: UIImageView = UIImageView()
    private let imageUrl: URL
    
    private let lastButton: UIButton = UIButton()
    private let nextButton: UIButton = UIButton()
    private let modeTitle: UILabel = UILabel()
    
    private let changeButton: UIButton = UIButton()
    private let filterButton: UIButton = UIButton()
    
    private let slider: SlidingRuler = SlidingRuler()
    
    private let modesCollectionView: UICollectionView = {
        let layout = CenteredFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.spaceBetweenCells
        layout.itemSize = .init(width: Constants.collectionHeight, height: .zero)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EditModeCollectionCell.self, forCellWithReuseIdentifier: Constants.modeCellIdentifier)
        collectionView.contentInset = .init(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private var cancelAction: UIAction {
        return UIAction { action in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private var saveAction: UIAction {
        return UIAction(title: Constants.saveTitle, image: Constants.saveImage) { action in
            
        }
    }
    
    private var sendAction: UIAction {
        return UIAction(title: Constants.sendTitle, image: Constants.sendImage) { action in
            
        }
    }
    
    private var convertAction: UIAction {
        return UIAction(title: Constants.convertTitle, image: Constants.convertImage) { action in
            
        }
    }
    
    private var doneActions: [UIAction] {
        [saveAction, sendAction, convertAction]
    }
    
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
        setupNavBar()
        setup()
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        let leftButton = makeBarButton(
            title: Constants.cancelTitle,
            titleColor: .appColor(.darkPurple),
            backgroundColor: .appColor(.frenchGray)
        )
        leftButton.addAction(cancelAction, for: .touchUpInside)
        
        let rightButton = makeBarButton(
            title: Constants.doneTitle,
            titleColor: .appColor(.linen),
            backgroundColor: .appColor(.amethyst)
        )
        rightButton.showsMenuAsPrimaryAction = true
        rightButton.menu = .init(children: doneActions)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    private func makeBarButton(title: String, titleColor: UIColor, backgroundColor: UIColor) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = Constants.buttonFont
        configuration.attributedTitle = .init(title, attributes: container)
        
        let button = UIButton(configuration: configuration)
        button.backgroundColor = backgroundColor
        button.tintColor = titleColor
        button.layer.cornerRadius = Constants.cornerRadius
        
        return button
    }
    
    private func setup() {
        view.backgroundColor = .black
        
        configureImageView()
        view.addSubview(imageView)
        
        configureCollectionView()
        view.addSubview(modesCollectionView)
        
        configureSlider()
        view.addSubview(slider)
    }
    
    private func configureImageView() {
        let navigationBarMaxY = navigationController?.navigationBar.frame.maxY ?? 0
        imageView.frame = .init(x: 0, y: navigationBarMaxY, width: view.bounds.width, height: view.bounds.width)
        imageView.contentMode = .scaleAspectFit
    }
    
    private func configureCollectionView() {
        modesCollectionView.delegate = self
        modesCollectionView.dataSource = self
        modesCollectionView.backgroundColor = .clear
        modesCollectionView.frame = .init(x: 0, y: imageView.frame.maxY, width: view.bounds.width, height: Constants.collectionHeight)
    }
    
    private func configureSlider() {
        slider.frame = .init(x: 0, y: modesCollectionView.frame.maxY, width: view.bounds.width, height: Constants.sliderHeight)
    }
}

// MARK: - Extensions

extension ImageEditorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.modes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Constants.modeCellIdentifier,
                for: indexPath) as? EditModeCollectionCell
        else {
            return .init()
        }
        
        let mode = model.modes[indexPath.row]
        if mode == model.currentMode {
            cell.isSelected = true
        }
        cell.configure(with: mode)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model.didSelectMode(at: indexPath.row)
        
        collectionView.reloadData()
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension ImageEditorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constants.collectionHeight, height: Constants.collectionHeight)
    }
}

// MARK: - Constants

private enum Constants {
    
    static let cancelTitle: String = "Отмена"
    static let doneTitle: String = "Готово"
    static let saveTitle: String = "Сохранить"
    static let sendTitle: String = "Отправить"
    static let convertTitle: String = "Преобразовать"
    
    static let saveImage: UIImage? = .init(systemName: "square.and.arrow.down")
    static let sendImage: UIImage? = .init(systemName: "paperplane")
    static let convertImage: UIImage? = .init(systemName: "arrow.2.squarepath")
    
    static let buttonFont: UIFont = .boldSystemFont(ofSize: 15)
    static let cornerRadius: CGFloat = 15
    
    static let modeCellIdentifier: String = "EditModeCollectionCell"
    static let collectionHeight: CGFloat = 50
    static let spaceBetweenCells: CGFloat = 20
    
    static let sliderHeight: CGFloat = 30
}
