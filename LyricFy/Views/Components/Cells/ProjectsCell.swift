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
        projectComponent.layer.cornerRadius = 20
        return projectComponent
    }()
    
    lazy var nameProject: UILabel = {
        let label = UILabel()
        label.font = .customFont(fontName: .ralewaySemibold, style: .headline, size: 17)
        label.textColor = .colors(name: .buttonsLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()
    
    lazy var dateDecribe: UILabel = {
        let label = UILabel()
        label.text = "Data de criação"
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .colors(name: .buttonsLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .colors(name: .buttonsLabel)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        [dateDecribe, date].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 13.5
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        [nameProject, dateStackView].forEach { stack.addArrangedSubview($0) }
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
            projectComponent.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2.29),
            projectComponent.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/6.5),
            
            stackView.leadingAnchor.constraint(equalTo: projectComponent.leadingAnchor, constant: 21),
            stackView.centerYAnchor.constraint(equalTo: projectComponent.centerYAnchor),
            
            dateStackView.bottomAnchor.constraint(equalTo: projectComponent.bottomAnchor, constant: -18),
            nameProject.widthAnchor.constraint(equalTo: projectComponent.widthAnchor, constant: -42)
        ])
    }
}
