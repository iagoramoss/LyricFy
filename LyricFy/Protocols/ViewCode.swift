//
//  ViewCode.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import Foundation

protocol ViewCode {

    func setupHierarchy()

    func setupConstraints()

    func setupAdditionalConfiguration()
}

extension ViewCode {

    func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }

    func setupHierarchy() {}

    func setupConstraints() {}

    func setupAdditionalConfiguration() {}
}
