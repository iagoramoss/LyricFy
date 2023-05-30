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
    
    override func loadView() {
        super.loadView()
        self.view = screen
    }
    
    private func setupView() {
        setupNavigationBar()
        
        screen.collectionProjects.delegate = self
        screen.collectionProjects.dataSource = self
        
        view.backgroundColor = .colors(name: .bgColor)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        
        viewModel.updateProjects()
        screen.collectionProjects.reloadData()
    }
    
    private func setupNavigationBar() {
        title = "Projects"
        
        let addProjectButton = UIBarButtonItem(
            image: .init(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(onTappedButtonAddProjects)
        )
        
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = addProjectButton.image?.withConfiguration(configuration)
        
        addProjectButton.image = image
        addProjectButton.tintColor = UIColor.colors(name: .buttonsColor)
        
        navigationItem.rightBarButtonItem = addProjectButton
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.colors(name: .buttonsColor)!,
            NSAttributedString.Key.font: UIFont.customFont(fontName: .ralewayBold, style: .largeTitle)
        ]
        
        navigationController?.navigationBar.barTintColor = UIColor.colors(name: .bgColor)
    }
    
    @objc
    func onTappedButtonAddProjects() {
        present(Alert(
            title: "Create Project",
            textFieldPlaceholder: "Ex: My Song",
            textFieldDefaultText: "Project",
            projectName: nil,
            action: { [weak self] projectName in
                guard let self = self else { return }
                
                var projectName = projectName
                
                if projectName.trimmingCharacters(in: .whitespaces).isEmpty {
                    let projectNames = self.viewModel.projects.map { $0.name }
                    var untitledCount = 0
                    
                    repeat {
                        projectName = "Untitled"
                        
                        if untitledCount > 0 {
                            projectName += " \(untitledCount)"
                        }
                        
                        untitledCount += 1
                    } while projectNames.contains(projectName)
                }
                
                self.viewModel.createProject(name: projectName)
                self.screen.collectionProjects.reloadData()
                
                self.navigateToComposition(composition: self.viewModel.projects.last!)
            }
        ), animated: true, completion: nil)
    }
    
    private func navigateToComposition(composition: Composition) {
        let compositionViewModel = CompositionViewModel(composition: composition)
        
        navigationController?.pushViewController(CompositionScreenController(viewModel: compositionViewModel),
                                                 animated: true)
        
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
        screen.placeHolder.isHidden = !viewModel.projects.isEmpty
        screen.numberOfProjects = viewModel.projects.count
        return viewModel.projects.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = screen.collectionProjects.dequeueReusableCell(
            withReuseIdentifier: ProjectsCell.identifier,
            for: indexPath
        ) as? ProjectsCell else { return UICollectionViewCell() }
        
        let projectDate = viewModel.projects[indexPath.row].createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: projectDate)
        
        cell.nameProject.text = viewModel.projects[indexPath.row].name
        cell.date.text = dateString
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2.29, height: UIScreen.main.bounds.height/6.5)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil) { [weak self] _ in
                let project = self!.viewModel.projects[indexPath.row]
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
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    private func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        let collectionView = screen.collectionProjects
        
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? ProjectsCell else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: selectedCell.projectComponent, parameters: parameters)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        navigateToComposition(composition: viewModel.projects[indexPath.item])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 16
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
        return UIAction(title: "Rename Project",
                        image: UIImage(systemName: "pencil"),
                        state: .off) { [weak self] _ in
            self?.present(Alert(
                title: "Rename Project",
                actionButtonLabel: "Rename",
                textFieldPlaceholder: nil,
                textFieldDefaultText: project.name,
                projectName: project.name,
                action: { [weak self] name in
                    if name.trimmingCharacters(in: .whitespaces).isEmpty {
                        return
                    }
                    
                    self?.viewModel.updateProjectName(projectId: project.id, newName: name)
                    collectionView.reloadData()
                }
            ), animated: true, completion: nil)
        }
    }
}
