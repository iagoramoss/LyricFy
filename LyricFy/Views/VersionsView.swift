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
    
    var labelModalTitle: UILabel = {
        let modalTitle = UILabel()
        modalTitle.text = "Choose a version"
        modalTitle.textAlignment = .center
        modalTitle.textColor = .black
        modalTitle.font = UIFont.boldSystemFont(ofSize: 17)

        return modalTitle
    }()
    
    var doneButton: UIButton = {
        let done = UIButton()
        done.setTitle("Done", for: .normal)
        done.setTitleColor(.systemBlue, for: .normal)
        done.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

        return done
    }()
    
    var cancelButton: UIButton = {
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.systemBlue, for: .normal)
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
        backgroundColor = .white
    }
}
