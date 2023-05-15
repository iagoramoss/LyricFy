//
//  CompositionScreenController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit
import Combine

class CompositionScreenController: UIViewController {
    
    private var partView: PartView?
    
    private var viewModel: CompositionViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: CompositionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        self.partView = PartView(delegate: self)
        self.view = partView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func reloadData() {
        partView?.tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        let menu = UIMenu(children: [
            UIAction(title: "See Versions",
                     image: UIImage(systemName: "arrow.triangle.branch"),
                     state: .off,
                     handler: { [weak self] _ in
                         self?.onTappedButtonVersion()
                     }),
            
            UIAction(title: "Create Versions",
                     image: UIImage(systemName: "plus"),
                     state: .off,
                     handler: { [weak self] _ in
                         self?.viewModel.createVersion()
                         self?.reloadData()
                     }),
            
            UIAction(title: "Delete Versions",
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive,
                     state: .off,
                     handler: { [weak self] _ in
                         self?.present(
                            Alert(title: "Do you want to delete this version?",
                                  message: "The version will be deleted and you will not be able to recover it.",
                                  actionButtonLabel: "Delete",
                                  actionButtonStyle: .destructive,
                                  preferredStyle: .alert,
                                  action: {
                                      if self?.viewModel.versions.count == 1 {
                                          self?.viewModel.deleteProject()
                                          self?.navigationController?.popViewController(animated: true)
                                          
                                          return
                                      }
                                      
                                      self?.viewModel.deleteVersion()
                                      self?.reloadData()
                                  }
                                 ),
                            animated: true)
                     })
        ])
        
        let addButton = UIBarButtonItem(image: .init(systemName: "plus"), style: .plain,
                                        target: self, action: #selector(onTappedButtonAdd))
        addButton.tintColor = .black
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))
        menuButton.menu = menu
        menuButton.tintColor = .black
        
        navigationItem.title = viewModel.name.capitalized
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [addButton, menuButton]
    }
    
    private func editPart(part: Part) {
        let lyricsViewModel = ScreenLyricsEditingViewModel(compositionPart: part) { [weak self] editedPart in
            self?.viewModel.updatePart(part: editedPart)
            self?.partView?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(ScreenLyricsEditingController(viewModel: lyricsViewModel),
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
        let versionsVC = VersionsViewController(versions: viewModel.versions.map({
            return $0.name
        }))
        
        versionsVC.doneAction = { [weak self] in
            self?.viewModel.switchVersion(to: versionsVC.versionsView.pickerView.selectedRow(inComponent: 0))
            self?.reloadData()
        }
        
        versionsVC.modalPresentationStyle = .pageSheet
        versionsVC.sheetPresentationController?.detents = [.medium()]
        versionsVC.sheetPresentationController?.prefersGrabberVisible = true
        
        present(versionsVC, animated: true)
        versionsVC.selectRow(row: viewModel.selectedVersionIndex)
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CompositionScreenController: PartTableView {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.parts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Composition.reuseIdentifier,
                                                       for: indexPath) as? PartCell
        else { return PartCell() }
        
        cell.part = viewModel.parts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = viewModel.parts[indexPath.row]
        
        return [item]
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        viewModel.dragAndDrop(from: sourceIndexPath, to: destinationIndexPath)
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
            return UIMenu(
                children: [
                    UIAction(title: "Duplicate") { [weak self] _ in
                        self?.viewModel.duplicatePart(index: indexPath)
                        tableView.reloadData()
                    },
                    UIAction(title: "Delete", attributes: .destructive) { [weak self] _ in
                        self?.present(
                            Alert(title: "",
                                  message: "This section will be deleted. And it will not be possible to recover it.",
                                  actionButtonLabel: "Delete",
                                  actionButtonStyle: .destructive,
                                  preferredStyle: .actionSheet,
                                  action: { [weak self] in
                                      self?.viewModel.deletePart(index: indexPath)
                                      tableView.reloadData()
                                  }),
                            animated: true)
                    }
                ])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let part = viewModel.parts[indexPath.row]
        editPart(part: part)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CompositionHeader.reuseIdentifier)
        
        guard let header = header as? CompositionHeader else { return header }
        
        header.version = viewModel.selectedVersionIndex + 1
        return header
    }
}
