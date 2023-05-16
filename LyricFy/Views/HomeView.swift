//
//  HomeView.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeView: UIView, ViewCode {
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 32, left: 20, bottom: 0, right: 20)
        return layout
    }()
    
    lazy var collectionProjects: UICollectionView = {
        let collectionProjects = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionProjects.translatesAutoresizingMaskIntoConstraints = false
        collectionProjects.backgroundColor = .none
        collectionProjects.register(ProjectsCell.self,
                                    forCellWithReuseIdentifier: ProjectsCell.identifier)
        collectionProjects.register(AddProjectsCell.self,
                                    forCellWithReuseIdentifier: AddProjectsCell.identifier)
        return collectionProjects
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    func setupHierarchy() {
        addSubview(collectionProjects)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionProjects.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionProjects.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionProjects.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionProjects.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
