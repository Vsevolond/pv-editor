import UIKit

// MARK: - Image Editor Model

final class ImageEditorModel {
    
    // MARK: - Internal Properties
    
    var modes: [EditingMode]
    var currentMode: EditingMode
    
    // MARK: - Private Properties
    
    // MARK: - Initializers
    
    init() {
        self.modes = CorrectionType.allCases.map { .correction($0) }
        self.currentMode = modes.first ?? .none
    }
    
    // MARK: - Internal Methods
    
    func didSelectMode(at index: Int) {
        currentMode = modes[index]
    }
}
