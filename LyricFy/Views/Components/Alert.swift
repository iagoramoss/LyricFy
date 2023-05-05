//
//  Alert.swift
//  LyricFy
//
//  Created by Iago Ramos on 28/04/23.
//

import Foundation
import UIKit

class Alert: UIAlertController {

    convenience init(title: String,
                     message: String,
                     cancelButtonLabel: String = "Cancel",
                     actionButtonLabel: String,
                     actionButtonStyle: UIAlertAction.Style,
                     preferredStyle: UIAlertController.Style,
                     action: @escaping () -> Void
    ) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        let cancelButton = UIAlertAction(title: cancelButtonLabel, style: .cancel)
        let actionButton = UIAlertAction(title: actionButtonLabel, style: actionButtonStyle, handler: { _ in action() })

        self.addAction(cancelButton)
        self.addAction(actionButton)
    }

    convenience init(title: String,
                     cancelButtonLabel: String = "Cancel",
                     actionButtonLabel: String = "Create",
                     textFieldPlaceholder: String,
                     textFieldDefaultText: String,
                     action: @escaping (String) -> Void
    ) {
        self.init(title: title, message: nil, preferredStyle: .alert)
        self.addTextField { textField in
            textField.placeholder = textFieldPlaceholder
        }

        let cancelButton = UIAlertAction(title: cancelButtonLabel, style: .cancel)
        let actionButton = UIAlertAction(title: actionButtonLabel, style: .default) { _ in
            guard let input = self.textFields?.first?.text, !input.isEmpty else { return }
            action(input)
        }

        self.addAction(cancelButton)
        self.addAction(actionButton)
    }
}
