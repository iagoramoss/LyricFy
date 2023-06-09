//
//  String+getUntitledString.swift
//  LyricFy
//
//  Created by Iago Ramos on 30/05/23.
//

import Foundation

extension String {
    mutating func handleTextFieldName(existingNames: [String]) {
        if !self.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        }
        
        self = "Untitled"
        
        var untitledCount = existingNames.filter({ $0.contains(self) }).count
        
        if untitledCount > 0 {
            self += " \(untitledCount)"
        }
    }
}
