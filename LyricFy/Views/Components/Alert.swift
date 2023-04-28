//
//  Alert.swift
//  LyricFy
//
//  Created by Iago Ramos on 28/04/23.
//

import Foundation
import UIKit

class Alert: UIAlertController {
    private var action: (() -> Void)?

    convenience init(title: String?,
                     message: String?,
                     cancelButtonText: String = "Cancel",
                     okButtonText: String = "OK",
                     action: (() -> Void)? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.action = action

        let cancelButton = UIAlertAction(title: cancelButtonText, style: .cancel)

        let okButton = UIAlertAction(title: okButtonText, style: .default) { _ in
            self.action?()
        }

        self.addAction(cancelButton)
        self.addAction(okButton)
    }

    convenience init(title: String,
                     okButtonText: String = "Create",
                     textFieldPlaceholder: String,
                     defaultText: String,
                     action: @escaping (String) -> Void) {
        self.init(title: title, message: nil, okButtonText: okButtonText)

        self.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
        }

        self.action = {
            guard let text = self.textFields?.first?.text else {
                return
            }

            action(text.isEmpty ? defaultText : text)
        }
    }
}
