import UIKit

// MARK: - Image Editor View Controller Protocol

protocol ImageEditorModelProtocol: AnyObject {
    
    func updateModeTitle(text: String)
    func updateCollection()
    func hideSlider()
    func showSlider()
    func flushSlider(to value: Int)
    func setValue(value: Int)
    func hideValue()
}

// MARK: - Image Editor Model

final class ImageEditorModel {
    
    // MARK: - Internal Properties
    
    var viewController: ImageEditorModelProtocol?
    
    var modes: [EditingMode]
    var currentIndexMode: Int = 0
    var currentMode: EditingMode {
        modes[currentIndexMode]
    }
    
    var imageParameters: ImageParameters
    
    var image: UIImage {
        imageParameters.image
    }
    
    // MARK: - Private Properties
    
    private var imageUrl: URL {
        imageParameters.imageUrl
    }
    
    // MARK: - Initializers
    
    init(imageUrl: URL) throws {
        modes = CorrectionType.allCases.map { .correction($0) }
        imageParameters = try ImageParameters(imageUrl: imageUrl)
    }
    
    deinit {
        try? FileManager.default.removeItem(at: imageUrl)
    }
    
    // MARK: - Internal Methods
    
    func didSelectMode(at index: Int) { // for correction and filter modes
        guard currentIndexMode != index else {
            viewController?.hideValue()
            return
        }
        
        currentIndexMode = index
        
        if case .correction(let type) = currentMode {
            let value = imageParameters.getValue(of: type)
            
            viewController?.flushSlider(to: value)
            viewController?.setValue(value: value)
        }
        viewController?.updateModeTitle(text: currentMode.title)
    }
    
    func didChangedMode(to index: Int) { // correction or filter mode
        if index == 0 {
            modes = CorrectionType.allCases.map { .correction($0) }
            viewController?.showSlider()
            
        } else if index == 1 {
            modes = FilterType.allCases.map { .filter($0) }
            viewController?.hideSlider()
            viewController?.hideValue()
        }
        
        didSelectMode(at: 0)
        viewController?.updateCollection()
    }
    
    func didChangedValue(_ value: Int) {
        switch currentMode {
            
        case .correction(let type):
            imageParameters.setCorrection(of: type, to: value)
            
        case .filter(let type):
            imageParameters.setFilter(type: type)
            
        case .none:
            return
        }
        viewController?.setValue(value: value)
    }
}
