//
//  ProjectsComponent.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class ProjectsComponent: UICollectionViewCell {
    
    static let identifier: String = "ProjectsCell"
    
    lazy var projectComponent: UIButton = {
        let projectComponent = UIButton()
        projectComponent.translatesAutoresizingMaskIntoConstraints = false
        projectComponent.backgroundColor = .green
        projectComponent.setTitle("AAA", for: .normal)
        projectComponent.setTitleColor(.blue, for: .normal)
        return projectComponent
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProjectsComponent: ViewCode {
    func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }

    func setupHierarchy() {
        addSubview(projectComponent)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            projectComponent.widthAnchor.constraint(equalToConstant: 200),
            projectComponent.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func setupAdditionalConfiguration() {}
}
