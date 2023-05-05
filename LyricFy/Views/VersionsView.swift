//
//  VersionsView.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 04/05/23.
//

import Foundation
import UIKit

class VersionsView: UIView {

    let pickerView: UIPickerView = UIPickerView()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VersionsView: ViewCode {
    func setupHierarchy() {
        self.addSubview(pickerView)
    }
    func setupConstraints() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            pickerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    func setupAdditionalConfiguration() {
        backgroundColor = .systemGray
    }
}
