import UIKit

// MARK: - UIButton Extensions

extension UIButton {
    
    func addAnimateAction(effect: some DiscreteSymbolEffect & SymbolEffect, for event: UIControl.Event, _ handler: @escaping () -> Void) {
        addAction(UIAction(handler: { action in
            if let sender = action.sender as? UIButton {
                sender.imageView?.addSymbolEffect(effect, options: .nonRepeating, animated: true, completion: { context in
                    if context.isFinished {
                        handler()
                    }
                })
            }
        }), for: event)
    }
}
