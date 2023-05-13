//
//  CompositionScreenController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit
import Combine

class CompositionScreenController: UIViewController {
    private var viewModel: CompositionViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private var songStructureView: SongStructureView?
    
    init(viewModel: CompositionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        self.subscriptions.forEach {
            $0.cancel()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.songStructureView = SongStructureView(delegate: self)
        self.view = songStructureView
        
        setupNavigationBar()
    }
    
    private func setupBindings() {
//        self.viewModel.$name.store
    }
    
    private func setupNavigationBar() {
        let menu = UIMenu(children: [
            UIAction(
                title: "See Versions",
                image: UIImage(systemName: "arrow.triangle.branch"),
                state: .off) { [weak self] _ in
                self?.onTappedButtonVersion()
            },
            UIAction(title: "Create Version",
                     image: UIImage(systemName: "plus"),
                     state: .off) { [weak self] _ in
                self?.viewModel.createVersion()
                self?.songStructureView?.tableView.reloadData()
            },
            UIAction(title: "Delete Version",
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive,
                     state: .off) { [weak self] _ in
                         self?.present(
                            Alert(title: "Do you want to delete this version?",
                                  message: "The version will be deleted and you will not be able to recover it.",
                                  actionButtonLabel: "Delete",
                                  actionButtonStyle: .destructive,
                                  preferredStyle: .alert, action: {
                                      if self?.viewModel.versions.count == 1 {
                                          self?.viewModel.deleteProject()
                                          self?.navigationController?.popViewController(animated: true)
                                          
                                          return
                                      }
                                      
                                      self?.viewModel.deleteVersion()
                                      self?.songStructureView?.tableView.reloadData()
                         }), animated: true)
            }
        ])
        
        let addButton = UIBarButtonItem(image: .init(systemName: "plus"), style: .plain,
        target: self, action: #selector(onTappedButtonAdd))
        addButton.tintColor = .black

        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))
        menuButton.menu = menu
        menuButton.tintColor = .black

        navigationItem.title = self.viewModel.name.capitalized
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [addButton, menuButton]
    }
    
    private func editPart(part: Part) {
        let lyricsViewModel = ScreenLyricsEditingViewModel(compositionPart: part) { [weak self] editedPart in
            self?.viewModel.updatePart(part: editedPart)
            self?.songStructureView?.tableView.reloadData()
        }
        
        self.navigationController?.pushViewController(ScreenLyricsEditingController(viewModel: lyricsViewModel),
                                                      animated: true)
    }

    @objc
    func onTappedButtonAdd() {
        let sheetVC = SheetViewController()
        
        sheetVC.action = { partType in
            self.dismiss(animated: true)
            self.viewModel.createPart(type: partType)
            
            let part = self.viewModel.parts.last!
            self.editPart(part: part)
        }
        
        sheetVC.modalPresentationStyle = .pageSheet
        sheetVC.sheetPresentationController?.detents = [.medium()]
        sheetVC.sheetPresentationController?.prefersGrabberVisible = true
        present(sheetVC, animated: true)
    }

    @objc
    func onTappedButtonVersion() {
        let versionsVC = VersionsViewController(versions: self.viewModel.versions.map({
            return $0.name
        }))
        
        versionsVC.doneAction = { [weak self] in
            self?.viewModel.switchVersion(to: versionsVC.versionsView.pickerView.selectedRow(inComponent: 0))
            self?.songStructureView?.tableView.reloadData()
        }
        
        versionsVC.modalPresentationStyle = .pageSheet
        versionsVC.sheetPresentationController?.detents = [.medium()]
        versionsVC.sheetPresentationController?.prefersGrabberVisible = true
        
        present(versionsVC, animated: true)
        versionsVC.selectRow(row: self.viewModel.selectedVersionIndex)
    }
}

extension CompositionScreenController: SongStructureTableView {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.parts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongStructure.reuseIdentifier,
                                                       for: indexPath) as? SongStructureCell
        else { return SongStructureCell() }
        
        cell.songStructure = self.viewModel.parts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = self.viewModel.parts[indexPath.row]
        
        return [item]
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        self.viewModel.dragAndDrop(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        
        return param
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(children: [
                
                UIAction(title: "Duplicate") { _ in
                    
                    self.viewModel.duplicatePart(index: indexPath)
                    tableView.reloadData()
                },
                UIAction(title: "Delete", attributes: .destructive) {[weak self] _ in
                    self?.present(
                        Alert(title: "",
                              message: "This section will be deleted. And it will not be possible to recover it.",
                              actionButtonLabel: "Delete",
                              actionButtonStyle: .destructive,
                              preferredStyle: .actionSheet) { [weak self] in
                                  
                                self?.viewModel.deletePart(index: indexPath)
                                tableView.reloadData()
                    }, animated: true)
                }
            ])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let part = self.viewModel.parts[indexPath.row]
        self.editPart(part: part)
    }
}
