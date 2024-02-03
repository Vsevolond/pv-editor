import UIKit

// MARK: - Image Editor View Controller Protocol

protocol ImageEditorModelProtocol: AnyObject {
    
    func updateModeTitle(text: String)
    func updateCollection()
    func hideSlider()
    func showSlider()
    func flushSlider()
}

// MARK: - Image Editor Model

final class ImageEditorModel {
    
    // MARK: - Internal Properties
    
    var viewController: ImageEditorModelProtocol?
    
    var modes: [EditingMode]
    var currentMode: EditingMode
    
    // MARK: - Private Properties
    
    // MARK: - Initializers
    
    init() {
        modes = CorrectionType.allCases.map { .correction($0) }
        currentMode = modes.first ?? .none
    }
    
    // MARK: - Internal Methods
    
    func didSelectMode(at index: Int) {
        currentMode = modes[index]
        viewController?.flushSlider()
        viewController?.updateModeTitle(text: currentMode.title)
    }
    
    func didChangedMode(to index: Int) {
        if index == 0 {
            modes = CorrectionType.allCases.map { .correction($0) }
            currentMode = modes.first ?? .none
            viewController?.showSlider()
        } else if index == 1 {
            modes = FilterType.allCases.map { .filter($0) }
            currentMode = modes.first ?? .none
            viewController?.hideSlider()
        }
        
        viewController?.updateCollection()
        viewController?.updateModeTitle(text: currentMode.title)
    }
}
