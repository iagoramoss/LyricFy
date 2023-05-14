//
//  AddProjectsCell.swift
//  LyricFy
//
//  Created by Marcos Costa on 04/05/23.
//

import Foundation
import UIKit

class AddProjectsCell: UICollectionViewCell {
    
    static let identifier: String = "AddProjectsCell"

    lazy var projectComponent: UIView = {
        let projectComponent = UIView()
        projectComponent.translatesAutoresizingMaskIntoConstraints = false
        projectComponent.backgroundColor = .colors(name: .sheetColor)
        projectComponent.layer.cornerRadius = 10
        return projectComponent
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .colors(name: .sheetButtonColor)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddProjectsCell: ViewCode {

    func setupHierarchy() {
        projectComponent.addSubview(image)
        addSubview(projectComponent)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            projectComponent.widthAnchor.constraint(equalToConstant: 166),
            projectComponent.heightAnchor.constraint(equalToConstant: 144),
            
            image.centerXAnchor.constraint(equalTo: projectComponent.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: projectComponent.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 50),
            image.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
