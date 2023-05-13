//
//  HomeViewController.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var screen = HomeView()
    
    var viewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        viewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.view = screen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        
        screen.collectionProjects.delegate = self
        screen.collectionProjects.dataSource = self
        
        screen.collectionProjects.reloadData()
        
        view.backgroundColor = .white
    }
    
    private func setupBindings() {
        
    }
    
    private func setupNavigationBar() {
        title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.projects.count + 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let addCell = screen.collectionProjects.dequeueReusableCell(
            withReuseIdentifier: AddProjectsCell.identifier,
            for: indexPath
        ) as? AddProjectsCell else { return UICollectionViewCell() }
        
        guard let cell = screen.collectionProjects.dequeueReusableCell(
            withReuseIdentifier: ProjectsCell.identifier,
            for: indexPath
        ) as? ProjectsCell else { return UICollectionViewCell() }
        
        guard indexPath.item > 0 else { return addCell }
        
        let projectDate = viewModel.projects[indexPath.row - 1].createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: projectDate)
        
        cell.nameProject.text = viewModel.projects[indexPath.row - 1].name
        cell.date.text = dateString
        
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
            previewProvider: nil) { [weak self] _ in
                let project = self!.viewModel.projects[indexPath.row - 1]
                return UIMenu(
                    title: "X",
                    children: [
                        self!.updateMenuAction(_: collectionView, project: project),
                        self!.deleteMenuAction(_: collectionView, project: project)
                    ]
                )
            }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if indexPath.item > 0 {
            let compositionViewModel = CompositionViewModel(composition: viewModel.projects[indexPath.item - 1])
            
            navigationController?.pushViewController(CompositionScreenController(viewModel: compositionViewModel),
                                                     animated: true)
        } else {
            self.present(Alert(
                title: "Create Project",
                textFieldPlaceholder: "X",
                textFieldDefaultText: "Projeto",
                projectName: nil,
                action: { [weak self] projectName in
                    self?.viewModel.createProject(name: projectName)
                    collectionView.reloadData()
                }
            ), animated: true, completion: nil)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 30
    }
    
    func deleteMenuAction (
        _ collectionView: UICollectionView,
        project: Composition
    ) -> UIAction {
        return UIAction(title: "Delete Project",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive,
                        state: .off) { [weak self] _ in
            self?.present(Alert(
                title: "Delete Project",
                message: "This project will be deleted. And it will not be possible to recover it.",
                actionButtonLabel: "Delete",
                actionButtonStyle: .destructive,
                preferredStyle: .actionSheet,
                action: { [weak self] in
                    self?.viewModel.deleteProject(projectId: project.id)
                    collectionView.reloadData()
                }
            ), animated: true, completion: nil)
        }
    }
    
    func updateMenuAction (
        _ collectionView: UICollectionView,
        project: Composition
    ) -> UIAction {
        return UIAction(title: "Edit name",
                        image: UIImage(systemName: "pencil.circle"),
                        state: .off) { [weak self] _ in
            self?.present(Alert(
                title: "Rename Project",
                textFieldPlaceholder: nil,
                textFieldDefaultText: project.name,
                projectName: project.name,
                action: { [weak self] name in
                    self?.viewModel.updateProjectName(projectId: project.id, newName: name)
                    collectionView.reloadData()
                }
            ), animated: true, completion: nil)
        }
    }
}
