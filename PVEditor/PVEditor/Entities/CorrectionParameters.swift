import Foundation

// MARK: - Correction Parameters

struct CorrectionParameters {
    
    // MARK: - Private Properties
    
    private let min: CGFloat
    private let max: CGFloat
    private let `default`: CGFloat
    
    private var maxDiff: CGFloat {
        max - `default`
    }
    
    private var minDiff: CGFloat {
        `default` - min
    }
    
    // MARK: - Initializers
    
    init(min: CGFloat, max: CGFloat, `default`: CGFloat) {
        self.min = min
        self.max = max
        self.default = `default`
    }
    
    // MARK: - Internal Methods
    
    func getValue(by value: Int) -> CGFloat {
        
        if value == 0 {
            return `default`
            
        } else if value > 0 {
            return maxDiff * CGFloat(value) / 100 + `default`
            
            
        } else {
            return minDiff * CGFloat(value) / 100 + `default`
            
        }
    }
}
