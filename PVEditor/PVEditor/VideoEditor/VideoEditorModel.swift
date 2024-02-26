import UIKit

// MARK: - Video Editor Model Protocol

protocol VideoEditorModelProtocol: AnyObject {
    
    func updateModeTitle(text: String)
    func updateCollection(center index: Int)
    func hideSlider()
    func showSlider()
    func flushSlider(to value: Int)
    func updateSlider(with range: ClosedRange<Int>)
    func setValue(value: Int)
    func hideValue()
    func updateFilter(filter: CIFilter?)
}

// MARK: - Video Editor Model

final class VideoEditorModel {
    
    // MARK: - Internal Properties
    
    var viewController: VideoEditorModelProtocol?
    
    var modes: [EditingMode]
    
    var lastIndexMode: (correction: Int, filter: Int) = (0, 0)
    var currentIndexMode: Int = 0
    
    var currentMode: EditingMode {
        modes[currentIndexMode]
    }
    
    // MARK: - Private Properties
    
    private var videoParameters: VideoParameters
    
    private var videoUrl: URL {
        videoParameters.videoUrl
    }
    
    // MARK: - Initializers
    
    init(videoUrl: URL) {
        modes = CorrectionType.allCases.map { .correction($0) }
        videoParameters = VideoParameters(videoUrl: videoUrl)
        
        videoParameters.onUpdateFilter { filter in
            self.viewController?.updateFilter(filter: filter)
        }
    }
    
    deinit {
        try? FileManager.default.removeItem(at: videoUrl)
    }
    
    // MARK: - Internal Methods
    
    func didSelectMode(at index: Int) { // for correction and filter modes
        currentIndexMode = index
        
        switch currentMode {
            
        case .correction(let type):
            let value = videoParameters.getValue(of: type)
            
            viewController?.updateSlider(with: type.range)
            viewController?.flushSlider(to: value)
            viewController?.setValue(value: value)
            
        case .filter(let type):
            videoParameters.setFilter(type: type)
            
        case .none:
            return
        }
        
        viewController?.updateModeTitle(text: currentMode.title)
    }
    
    func didChangedMode(to index: Int) { // correction or filter mode
        var center: Int = 0
        
        if index == 0 {
            lastIndexMode.filter = currentIndexMode
            center = lastIndexMode.correction
            
            modes = CorrectionType.allCases.map { .correction($0) }
            
            viewController?.showSlider()
            
        } else if index == 1 {
            lastIndexMode.correction = currentIndexMode
            center = lastIndexMode.filter
            
            modes = FilterType.allCases.map { .filter($0) }
            
            viewController?.hideSlider()
            viewController?.hideValue()
        }
        
        didSelectMode(at: center)
        viewController?.updateCollection(center: center)
    }
    
    func didChangedValue(_ value: Int) {
        switch currentMode {
            
        case .correction(let type):
            videoParameters.setCorrection(of: type, to: value)
            
        default:
            return
        }
        viewController?.setValue(value: value)
    }
    
    func updateCurrentSnapshot(_ snapshot: CIImage) {
        videoParameters.updateFiltersImage(image: snapshot)
    }
}
