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
        let collectionProjects = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionProjects.translatesAutoresizingMaskIntoConstraints = false
        collectionProjects.backgroundColor = .none
        collectionProjects.register(ProjectsCell.self,
                                    forCellWithReuseIdentifier: ProjectsCell.identifier)
        collectionProjects.register(AddProjectsCell.self, forCellWithReuseIdentifier: AddProjectsCell.identifier)
        //        collectionProjects.setCollectionViewLayout(layout, animated: false)
        collectionProjects.delegate = self
        collectionProjects.dataSource = self
        
        return collectionProjects
    }()
    
    override init(frame: CGRect) {
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

extension HomeView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count + 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let addCell = collectionProjects.dequeueReusableCell(
            withReuseIdentifier: AddProjectsCell.identifier,
            for: indexPath
        ) as? AddProjectsCell
        
        let cell = collectionProjects.dequeueReusableCell(
            withReuseIdentifier: ProjectsCell.identifier,
            for: indexPath
        ) as? ProjectsCell
        if indexPath.item > 0 {
            cell?.nameProject.text = projects[indexPath.row - 1].projectName
            cell?.date.text = projects[indexPath.row - 1].date
            return cell ?? UICollectionViewCell()
        } else {
            return addCell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 166, height: 144)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        if indexPath.item > 0 {
            return UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: nil) { _ in
                return UIMenu(title: "X",
                              children: [
                                UIAction(title: "Edit name",
                                         image: UIImage(systemName: "pencil.circle"),
                                         state: .off) { _ in
                                             print("edit name")
                                         },
                                UIAction(title: "Delete Project",
                                         image: UIImage(systemName: "trash"),
                                         attributes: .destructive,
                                         state: .off) { _ in
                                             print("delete version")
                                             
                                         }
                              ]
                )
            }
        } else {
            return nil
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.item > 0 {
            NotificationCenter.default.post(.init(name: Notification.Name(rawValue: "emptyView")))
        } else {
            print("ädicionar")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 30
    }
    
}
