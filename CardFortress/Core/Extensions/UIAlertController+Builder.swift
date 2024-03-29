//
//  UIAlertController+Builder.swift
//  CardFortress
//
//  Created by Roberto Corrales on 1/05/23.
//

import UIKit

extension UIAlertController {

    final class Builder {

        private var title: String?
        private var message: String?
        private var actions: [UIAlertAction] = []
        private var alertStyle: UIAlertController.Style = .alert
        private var showTextField = false
        private var textFields: [((UITextField) -> Void)?]?

        @discardableResult func withTitle(_ title: String?) -> Builder {
            self.title = title
            return self
        }

        @discardableResult func withMessage(_ message: String?) -> Builder {
            self.message = message
            return self
        }

        @discardableResult func withButton(style: UIAlertAction.Style = .default,
                                           title: String,
                                           callback: ((Builder) -> Void)? = nil) -> Builder {

            let cancelAction = UIAlertAction(title: title,
                                             style: style,
                                             handler: { _ in callback?(self) })

            actions.append(cancelAction)
            return self
        }

        @discardableResult func withAlertStyle(_ style: UIAlertController.Style) -> Builder {
            self.alertStyle = style
            return self
        }

        @discardableResult func withTextField(_ showTextField: Bool) -> Builder {
            self.showTextField = showTextField
            return self
        }
        
        @discardableResult func addTextField(_ textFields: [((UITextField) -> Void)?]) -> Builder {
            self.textFields = textFields
            return self
        }
        
        @discardableResult func addActions(_ actions: [UIAlertAction]) -> Builder {
            self.actions = actions
            return self
        }

        func present(in viewController: UIViewController) {
                guard viewController.isViewLoaded, viewController.view.window != nil else { return }
                let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: self.alertStyle)
                if self.showTextField {
                    alert.addTextField()
                    self.textFields?.forEach {
                        alert.addTextField(configurationHandler: $0)
                    }
                }
                self.actions.forEach { alert.addAction($0) }
                viewController.present(alert, animated: true)
        }
    }
}

extension UIViewController {
    func presentAlert(with error: Error) {
        UIAlertController
            .Builder()
            .withTitle(NSLocalizedString("Error", comment: "Error title shown in modal"))
            .withMessage(error.localizedDescription)
            .withButton(title: NSLocalizedString("OK", comment: "OK Button title shown in modal"))
            .present(in: self)
    }
    
    func presentAlert(with error: String) {
        UIAlertController
            .Builder()
            .withTitle(NSLocalizedString("Error", comment: "Error title shown in modal"))
            .withMessage(error)
            .withButton(title: NSLocalizedString("OK", comment: "OK Button title shown in modal"))
            .present(in: self)
    }
}

#if DEBUG
extension UIAlertController.Builder {
    struct TestHooks {
        let target: UIAlertController.Builder
        
        init(target: UIAlertController.Builder) {
            self.target = target
        }
        
        var actions: [UIAlertAction] {
            target.actions
        }
        
        var title: String? {
            target.title
        }
        
        var message: String? {
            target.message
        }
        
        var alertStyle: UIAlertController.Style {
            target.alertStyle
        }
        
        var showTextField: Bool {
            target.showTextField
        }
        
        var textFields: [((UITextField) -> Void)?]? {
            target.textFields
        }
    }
    
    var testHooks: TestHooks {
        TestHooks(target: self)
    }
}
#endif

