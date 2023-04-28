//
//  NewProjectAlert.swift
//  LyricFy
//
//  Created by Iago Ramos on 28/04/23.
//

import Foundation
import UIKit

class NewProjectAlert: UIAlertController {
    convenience init(action: @escaping (String) -> Void) {
        self.init(title: "Nome da pasta", message: nil, preferredStyle: .alert)

        self.addTextField { (textField) in
            textField.placeholder = "Nome"
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        let save = UIAlertAction(title: "Save", style: .default) { _ in
            let name = self.textFields!.first!.text!
            action(name.isEmpty ? "sem título" : name)
        }

        self.addAction(cancel)
        self.addAction(save)
    }
}
