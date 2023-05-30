//
//  KeyboardListenerProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 04/05/23.
//

import Foundation

protocol KeyboardListenerDelegate: AnyObject {
    
    func keyboardWillAppear()
    func keyboardWillhide()
}
