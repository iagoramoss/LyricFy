//
//  HomeViewController.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var screen = HomeView()
    
    private var viewModel: HomeViewModel
    
    init(homeViewModel: HomeViewModel) {
        viewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    override func loadView() {
        super.loadView()
        self.view = screen
    }
    
    private func setupView() {
        screen.collectionProjects.delegate = self
        screen.collectionProjects.dataSource = self
        
        screen.collectionProjects.reloadData()
        
        view.backgroundColor = .colors(name: .bgColor)
    }
    
    private func setupNavigationBar() {
        title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.colors(name: .buttonsColor)!
        ]
    }
    
    private func navigateToComposition(composition: Composition) {
        let compositionViewModel = CompositionViewModel(composition: composition)
        
        navigationController?.pushViewController(CompositionScreenController(viewModel: compositionViewModel),
                                                 animated: true)

//        NSAttributedString.Key.foregroundColor: UIColor.colors(name: .buttonsColor) ?? nil,
//            NSAttributedString.Key.font: .fontCustom( fontName: .ralewayBold, size: 45) ?? UIFont.systemFont(ofSize: 45)

        UINavigationBar.appearance().layoutMargins.left = 80
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
        return CGSize(width: 168, height: 162)
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
            navigateToComposition(composition: viewModel.projects[indexPath.item - 1])
        } else {
            present(Alert(
                title: "Create Project",
                textFieldPlaceholder: "Ex: My Song",
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
        return 20
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
