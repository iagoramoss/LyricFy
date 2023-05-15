//
//  CompositionHeaderCell.swift
//  LyricFy
//
//  Created by Iago Ramos on 15/05/23.
//

import Foundation
import UIKit

class CompositionHeader: UITableViewHeaderFooterView, ViewCode {
    static let reuseIdentifier = String(describing: CompositionHeader.self)
    
    var version: Int = 1 {
        didSet {
            versionLabel.text = "Version \(version)"
        }
    }
    
    private lazy var versionLabel: UILabel = {
        let version = UILabel()
        version.font = UIFont.preferredFont(for: .subheadline, weight: .regular)
        version.textColor = UIColor(red: 0.294, green: 0.327, blue: 0.508, alpha: 1)
        return version
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        addSubview(versionLabel)
    }
    
    func setupConstraints() {
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            versionLabel.topAnchor.constraint(equalTo: topAnchor),
            versionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            versionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
