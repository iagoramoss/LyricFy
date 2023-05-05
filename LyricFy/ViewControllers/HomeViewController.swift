//
//  HomeViewController.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var screen: HomeView?
    
    var projects: [Project] = HomeViewModel().projects
    
    override func loadView() {
        super.loadView()
        self.screen = HomeView()
        self.view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        screen?.collectionProjects.delegate = self
        screen?.collectionProjects.dataSource = self
        
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return projects.count + 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard indexPath.item > 0 else { return UICollectionViewCell() }
        
        let addCell = screen?.collectionProjects.dequeueReusableCell(
            withReuseIdentifier: AddProjectsCell.identifier,
            for: indexPath
        ) as? AddProjectsCell
        
        guard let cell = screen?.collectionProjects.dequeueReusableCell(
            withReuseIdentifier: ProjectsCell.identifier,
            for: indexPath
        ) as? ProjectsCell else { return UICollectionViewCell() }
        
        cell.nameProject.text = projects[indexPath.row - 1].projectName
        cell.date.text = projects[indexPath.row - 1].date
        return cell
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
        guard indexPath.item > 0 else { return nil }
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                return UIMenu(title: "X",
                              children: [
                                UIAction(title: "Edit name",
                                         image: UIImage(systemName: "pencil.circle"),
                                         state: .off) { _ in
                                             self.present(Alert(
                                                title: "Rename Project",
                                                textFieldPlaceholder: self.projects[indexPath.row - 1].projectName,
                                                textFieldDefaultText: "Projeto",
                                                action: { projectName in
                                                    
                                                    let project = Project(
                                                        projectName: projectName,
                                                        date: self.projects[indexPath.row - 1].date
                                                    )
                                                    self.projects[indexPath.row - 1] = project
                                                    collectionView.reloadData()
                                                    
                                                }), animated: true, completion: nil)
                                         },
                                UIAction(title: "Delete Project",
                                         image: UIImage(systemName: "trash"),
                                         attributes: .destructive,
                                         state: .off) { _ in
                                             self.present(Alert(
                                                title: "Delete Project",
                                                message: "X",
                                                actionButtonLabel: "Delete",
                                                actionButtonStyle: .destructive,
                                                preferredStyle: .actionSheet,
                                                action: {
                                                    self.projects.remove(at: indexPath.row-1)
                                                    collectionView.deleteItems(at: [indexPath])
                                                }), animated: true, completion: nil)
                                         }
                              ]
                )
            }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.item > 0 {
            navigationController?.pushViewController(CompositionScreenController(), animated: true)
        } else {
            self.present(Alert(
                title: "Create Project",
                textFieldPlaceholder: "X",
                textFieldDefaultText: "Projeto",
                action: { projectName in
                    
                    let project: Project = Project(projectName: projectName, date: "a")
                    self.projects.insert(project, at: self.projects.startIndex)
                    
                    let indexPath = IndexPath(item: 1, section: 0)
                    
                    collectionView.insertItems(at: [indexPath])
                    
                }), animated: true, completion: nil)
            
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
