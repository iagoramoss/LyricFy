//
//  UITextView+Combine.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Combine
import UIKit

extension UITextView {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification,
            object: self
        )
        .map { notification in
            guard let textView = notification.object as? UITextView else {
                return ""
            }
            return textView.text
        }
        .eraseToAnyPublisher()
    }
}
