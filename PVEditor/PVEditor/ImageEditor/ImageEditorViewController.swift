import UIKit

// MARK: - ImageEditorViewController

final class ImageEditorViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    override var prefersStatusBarHidden: Bool { true }
    
    // MARK: - Private Properties
    
    private let model: ImageEditorModel
    
    private let imageView: ImageMetalView = ImageMetalView()
    
    private var doneButton: UIButton = UIButton()
    private var cancelButton: UIButton = UIButton()
    
    private let lastButton: UIButton = UIButton()
    private let nextButton: UIButton = UIButton()
    private let modeTitle: UILabel = UILabel()
    
    private let modeSegmentedControl: UISegmentedControl = UISegmentedControl(items: EditingMode.titles)
    
    private let slider: SlidingRuler = SlidingRuler()
    private let valueLabel: UILabel = UILabel()
    
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
    
    private lazy var cancelAction: UIAction = UIAction { action in
        self.dismiss(animated: true)
    }
    
    private var saveAction: UIAction = UIAction(title: Constants.saveTitle, image: Constants.saveImage) { _ in
        
    }
    
    private var sendAction: UIAction = UIAction(title: Constants.sendTitle, image: Constants.sendImage) { _ in
        
    }
    
    private var convertAction: UIAction = UIAction(title: Constants.convertTitle, image: Constants.convertImage) { _ in
        
    }
    
    private var doneActions: [UIAction] {
        [saveAction, sendAction, convertAction]
    }
    
    private lazy var modeChangedAction: UIAction = UIAction { _ in
        let index = self.modeSegmentedControl.selectedSegmentIndex
        self.model.didChangedMode(to: index)
    }
    
    private var lastStepAction: UIAction = UIAction { _ in
        
    }
    
    private var nextStepAction: UIAction = UIAction { _ in
    }
    
    // MARK: - Initializers
    
    init(imageUrl: URL) {
        do {
            self.model = try ImageEditorModel(imageUrl: imageUrl)
        } catch {
            fatalError("image can't be loaded")
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.image = model.image
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = .black
        
        configureControlBarButtons()
        configureLastButton()
        configureNextButton()
        configureModeTitle()
        configureValueLabel()
        configureCollectionView()
        configureSegmentedControl()
        
        model.viewController = self
        slider.onValueChanged = model.didChangedValue(_:)
    }
    
    private func layout() {
        cancelButton.frame = .init(x: Constants.barHorizontalPadding, y: view.frame.minY + Constants.padding * 2,
                                   width: Constants.barButtonWidth, height: Constants.barButtonHeight)
        view.addSubview(cancelButton)
        
        doneButton.frame = .init(x: view.bounds.width - Constants.barHorizontalPadding - Constants.barButtonWidth,
                                 y: cancelButton.frame.minY, width: Constants.barButtonWidth, height: Constants.barButtonHeight)
        view.addSubview(doneButton)
        
        lastButton.frame = .init(x: Constants.padding, y: cancelButton.frame.maxY + Constants.padding * 2,
                                 width: Constants.stepControlButtonSize + 2, height: Constants.stepControlButtonSize)
        view.addSubview(lastButton)
        
        nextButton.frame = .init(x: lastButton.frame.maxX + Constants.padding, y: lastButton.frame.minY,
                                 width: Constants.stepControlButtonSize + 2, height: Constants.stepControlButtonSize)
        view.addSubview(nextButton)
        
        modeTitle.frame.size = .init(width: (view.center.x - nextButton.frame.maxX) * 2, height: Constants.stepControlButtonSize)
        modeTitle.center = .init(x: view.center.x, y: nextButton.center.y)
        view.addSubview(modeTitle)
        
        imageView.frame = .init(x: 0, y: modeTitle.frame.maxY + Constants.padding, width: view.bounds.width, height: view.bounds.width * 4/3)
        view.addSubview(imageView)
        
        valueLabel.frame.size = .init(width: Constants.valueWidth, height: Constants.valueHeight)
        valueLabel.center = .init(x: imageView.center.x, y: imageView.frame.maxY - Constants.valueHeight / 2 - Constants.padding)
        view.addSubview(valueLabel)
        
        modesCollectionView.frame = .init(x: 0, y: imageView.frame.maxY + Constants.padding,
                                          width: view.bounds.width, height: Constants.collectionHeight)
        view.addSubview(modesCollectionView)
        
        slider.frame = .init(x: 0, y: modesCollectionView.frame.maxY + Constants.padding,
                             width: view.bounds.width, height: Constants.sliderHeight)
        view.addSubview(slider)
        
        modeSegmentedControl.frame = .init(x: view.bounds.midX - Constants.segmentedControlWidth / 2,
                                           y: view.bounds.maxY - Constants.segmentedControlHeight * 2,
                                           width: Constants.segmentedControlWidth, height: Constants.segmentedControlHeight)
        view.addSubview(modeSegmentedControl)
    }
    
    private func configureControlBarButtons() {
        cancelButton = makeBarButton(
            title: Constants.cancelTitle,
            titleColor: .appColor(.darkPurple),
            backgroundColor: .appColor(.frenchGray)
        )
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        
        doneButton = makeBarButton(
            title: Constants.doneTitle,
            titleColor: .appColor(.linen),
            backgroundColor: .appColor(.amethyst)
        )
        doneButton.showsMenuAsPrimaryAction = true
        doneButton.menu = .init(children: doneActions)
    }
    
    private func makeBarButton(title: String, titleColor: UIColor, backgroundColor: UIColor) -> UIButton {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = Constants.buttonFont
        configuration.attributedTitle = .init(title, attributes: container)
        configuration.contentInsets = .init(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let button = UIButton(configuration: configuration)
        button.backgroundColor = backgroundColor
        button.tintColor = titleColor
        button.layer.cornerRadius = Constants.barButtonHeight / 2
        
        return button
    }
    
    private func configureLastButton() {
        lastButton.setBackgroundImage(Constants.lastImage, for: .normal)
        lastButton.tintColor = .white
        lastButton.isEnabled = false
        lastButton.addAction(lastStepAction, for: .touchUpInside)
    }
    
    private func configureNextButton() {
        nextButton.setBackgroundImage(Constants.nextImage, for: .normal)
        nextButton.tintColor = .white
        nextButton.isEnabled = false
        nextButton.addAction(nextStepAction, for: .touchUpInside)
    }
    
    private func configureModeTitle() {
        modeTitle.text = model.currentMode.title
        modeTitle.textAlignment = .center
        modeTitle.font = .boldSystemFont(ofSize: 16)
        modeTitle.textColor = .appColor(.frenchGray)
    }
    
    private func configureValueLabel() {
        valueLabel.layer.cornerRadius = Constants.valueHeight / 2
        valueLabel.clipsToBounds = true
        valueLabel.textAlignment = .center
        valueLabel.textColor = .white
        valueLabel.backgroundColor = .appColor(.amethyst)
        valueLabel.font = .boldSystemFont(ofSize: 16)
        valueLabel.isHidden = true
    }
    
    private func configureCollectionView() {
        modesCollectionView.delegate = self
        modesCollectionView.dataSource = self
        modesCollectionView.backgroundColor = .clear
    }
    
    private func configureSegmentedControl() {
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        modeSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        modeSegmentedControl.selectedSegmentTintColor = .appColor(.tropicalIndigo)
        modeSegmentedControl.addAction(modeChangedAction, for: .valueChanged)
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

extension ImageEditorViewController: ImageEditorModelProtocol {
    
    func updateSlider(with range: ClosedRange<Int>) {
        slider.range = range
    }
    
    func updateImage(to image: CIImage) {
        imageView.image = image
    }
    
    func hideValue() {
        UIView.animate(withDuration: 0.3) {
            self.valueLabel.alpha = 0
        } completion: { _ in
            self.valueLabel.isHidden = true
        }
    }
    
    func setValue(value: Int) {
        valueLabel.text = "\(value)"
        valueLabel.alpha = 1
        valueLabel.isHidden = false
        
        slider.doAfterEndDecelerating { [weak self] in
            self?.hideValue()
        }
    }
    
    func flushSlider(to value: Int) {
        slider.isEnabled = false
        slider.doAfterEndScrolling { [weak self] in
            self?.slider.isEnabled = true
        }
        slider.flush(to: value)
    }
    
    func hideSlider() {
        UIView.animate(withDuration: 0.3) {
            self.slider.alpha = 0
        } completion: { _ in
            self.slider.isHidden = true
        }
    }
    
    func showSlider() {
        slider.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.slider.alpha = 1
        }
    }
    
    func updateModeTitle(text: String) {
        modeTitle.text = text
    }
    
    func updateCollection() {
        modesCollectionView.reloadData()
        modesCollectionView.scrollToItem(at: .init(row: 0, section: 0), at: .centeredHorizontally, animated: true)
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
    
    static let buttonFont: UIFont = .boldSystemFont(ofSize: 16)
    
    static let modeCellIdentifier: String = "EditModeCollectionCell"
    static let collectionHeight: CGFloat = 50
    static let spaceBetweenCells: CGFloat = 20
    
    static let sliderHeight: CGFloat = 30
    
    static let segmentedControlWidth: CGFloat = 200
    static let segmentedControlHeight: CGFloat = 30
    
    static let padding: CGFloat = 10
    
    static let lastImage: UIImage? = UIImage(systemName: "arrow.uturn.left.circle")
    static let nextImage: UIImage? = UIImage(systemName: "arrow.uturn.right.circle")
    
    static let stepControlButtonSize: CGFloat = 30
    
    static let valueWidth: CGFloat = 50
    static let valueHeight: CGFloat = 30
    
    static let barButtonWidth: CGFloat = 70
    static let barButtonHeight: CGFloat = 30
    static let barHorizontalPadding: CGFloat = 20
}
