//
//  ProjectsCell.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class ProjectsCell: UICollectionViewCell {
    
    static let identifier: String = "ProjectsCell"
        
    lazy var projectComponent: UIView = {
        let projectComponent = UIView()
        projectComponent.translatesAutoresizingMaskIntoConstraints = false
        projectComponent.backgroundColor = .colors(name: .buttonsColor)
        projectComponent.layer.cornerRadius = 28
        return projectComponent
    }()
    
    lazy var nameProject: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontName: .ralewaySemibold, style: .headline, size: 17)
        label.textColor = .colors(name: .buttonsLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.font = .systemFont(ofSize: 13)
        label.textColor = .colors(name: .buttonsLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        [nameProject, date].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProjectsCell: ViewCode {

    func setupHierarchy() {
        projectComponent.addSubview(stackView)
        addSubview(projectComponent)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            projectComponent.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            projectComponent.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            projectComponent.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            projectComponent.widthAnchor.constraint(equalToConstant: 168),
            projectComponent.heightAnchor.constraint(equalToConstant: 162),
            
            stackView.centerXAnchor.constraint(equalTo: projectComponent.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: projectComponent.centerYAnchor),
            
            nameProject.widthAnchor.constraint(equalTo: projectComponent.widthAnchor, constant: -30)
        ])
    }
}
