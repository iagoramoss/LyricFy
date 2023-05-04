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
        projectComponent.backgroundColor = .lightGray
        projectComponent.layer.cornerRadius = 10
        return projectComponent
    }()
    
    lazy var nameProject: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        [nameProject, date].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func newScreen() {
        NotificationCenter.default.post(.init(name: Notification.Name(rawValue: "emptyView")))
    }
}

extension ProjectsCell: ViewCode {
    func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }

    func setupHierarchy() {
        projectComponent.addSubview(stackView)
        addSubview(projectComponent)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            projectComponent.widthAnchor.constraint(equalToConstant: 166),
            projectComponent.heightAnchor.constraint(equalToConstant: 144),
            
            stackView.centerXAnchor.constraint(equalTo: projectComponent.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: projectComponent.centerYAnchor)
        ])
    }

    func setupAdditionalConfiguration() {}
}
