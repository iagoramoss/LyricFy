//
//  Extension+ViewCode.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit

protocol ViewCode {
    func setupHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension ViewCode {
    func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
}
