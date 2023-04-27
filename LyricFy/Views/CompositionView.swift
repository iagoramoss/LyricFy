//
//  CompositionView.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit

class CompositionView: UIView {
    var nameOfMusic: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Somewhere only we know"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CompositionView: ViewCode {
    func setupHierarchy() {
        addSubview(self.nameOfMusic)
    }
    func setupConstraints() {
        nameOfMusic.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        nameOfMusic.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameOfMusic.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameOfMusic.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    func setupAdditionalConfiguration() {
        backgroundColor = .brown
    }
}
