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
    
    lazy var labelModalTitle: UILabel = {
        let modalTitle = UILabel()
        modalTitle.text = "Choose a version"
        modalTitle.textAlignment = .center
        modalTitle.textColor = .black
        modalTitle.font = UIFont.boldSystemFont(ofSize: 17)
        return modalTitle
    }()
    
    lazy var doneButton: UIButton = {
        let done = UIButton()
        done.setTitle("Done", for: .normal)
        done.setTitleColor(UIColor(red: 0.21, green: 0.27, blue: 0.62, alpha: 1.0), for: .normal)
        done.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return done
    }()

    lazy var cancelButton: UIButton = {
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(UIColor(red: 0.21, green: 0.27, blue: 0.62, alpha: 1.0), for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return cancel
    }()

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
        self.addSubview(doneButton)
        self.addSubview(cancelButton)
        self.addSubview(labelModalTitle)
        self.addSubview(pickerView)
    }
    func setupConstraints() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        labelModalTitle.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            pickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            cancelButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),

            labelModalTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 23),
            labelModalTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            doneButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    func setupAdditionalConfiguration() {
        backgroundColor = .colors(name: .sheetColor)
    }
}
