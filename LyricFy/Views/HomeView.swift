//
//  HomeView.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeView: UIView {
    
    var projects: [Project] = HomeViewModel().projects
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    lazy var collectionProjects: UICollectionView = {
        let collectionProjects = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionProjects.translatesAutoresizingMaskIntoConstraints = false
        collectionProjects.backgroundColor = .none
        collectionProjects.register(ProjectsCell.self,
                                    forCellWithReuseIdentifier: ProjectsCell.identifier)
        collectionProjects.register(AddProjectsCell.self, forCellWithReuseIdentifier: AddProjectsCell.identifier)
        
        return collectionProjects
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: ViewCode {
    func setupHierarchy() {
        addSubview(self.collectionProjects)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionProjects.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionProjects.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            collectionProjects.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            collectionProjects.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
