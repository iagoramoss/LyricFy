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

    private var firstLoad: Bool = true

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
        navigationController?.navigationBar.tintColor = .colors(name: .barButtonColor)
    }

    private func setupNavigationBar() {
        let menu = UIMenu(children: [
            UIAction(title: "Change version",
                     image: UIImage(systemName: "arrow.triangle.branch"),
                     state: .off,
                     handler: { [weak self] _ in
                         self?.onTappedButtonVersion()
                     }),
            
            UIAction(title: "Duplicate version",
                     image: UIImage(systemName: "doc.on.doc"),
                     state: .off,
                     handler: { [weak self] _ in
                         self?.viewModel.createVersion()
                         self?.navigationItem.title = self?.viewModel.selectedVersionName
                         self?.reloadData()
                     }),
            
            UIAction(title: "Delete version",
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive,
                     state: .off,
                     handler: { [weak self] _ in
                         self?.present( Alert(title: "Do you want to delete this version?",
                                  message: "The version will be deleted and you will not be able to recover it.",
                                  actionButtonLabel: "Delete",
                                  actionButtonStyle: .destructive,
                                  preferredStyle: .actionSheet,
                                  action: {
                                      if self?.viewModel.versions.count == 1 {
                                          self?.viewModel.deleteProject()
                                          self?.navigationController?.popViewController(animated: true)
                                          return
                                      }

                                      self?.viewModel.deleteVersion()
                                      self?.reloadData()
                                  }),
                            animated: true)
                     })
        ])
        
        let addButton = UIBarButtonItem(image: .init(systemName: "plus"), style: .plain,
                                        target: self, action: #selector(onTappedButtonAdd))
        addButton.tintColor = .colors(name: .barButtonColor)
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))
        menuButton.menu = menu
        menuButton.tintColor = .colors(name: .barButtonColor)
        
        navigationItem.title = viewModel.selectedVersionName
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.colors(name: .buttonsColor)!
        ]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [addButton, menuButton]
    }
    
    private func editPart(part: Part) {
        let lyricsViewModel = ScreenLyricsEditingViewModel(compositionPart: part,
                                                           dataManager: DataAccessManager.shared,
                                                           audioManager: AudioController.shared,
                                                           audioFileManager: LocalAudioFileManager.shared)
        
        navigationController?.pushViewController(ScreenLyricsEditingController(viewModel: lyricsViewModel,
                                                                               delegate: self),
                                                 animated: true)
    }
    
    @objc
    func onTappedButtonAdd() {
        let sheetVC = SheetViewController()
        
        sheetVC.action = { [weak self] partType in
            self?.dismiss(animated: true)
            guard let self = self else { return }
            
            self.viewModel.createPart(type: partType)
            
            let part = self.viewModel.parts.last!
            self.editPart(part: part)
        }
        
        if #available(iOS 16.0, *) {
            sheetVC.sheetPresentationController?.detents = [.custom(resolver: { _ in
                return 200
            })]
        } else {
            sheetVC.sheetPresentationController?.detents = [.medium()]
        }
        
        sheetVC.modalPresentationStyle = .pageSheet
        
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
            self?.navigationItem.title = self?.viewModel.selectedVersionName
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

extension CompositionScreenController: PartDelegate {
    
    func reloadData() {
        viewModel.updateParts()
        partView?.tableView.reloadData()
    }
    
    func tableView(
        _ tableView: UITableView,
        performDropWith coordinator: UITableViewDropCoordinator
    ) {}
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if viewModel.parts.isEmpty {
            partView?.imageView.isHidden = false
            partView?.placeholder.isHidden = false
        } else {
            partView?.imageView.isHidden = true
            partView?.placeholder.isHidden = true
        }
        return viewModel.parts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PartCell.reuseIdentifier,
            for: indexPath
        ) as? PartCell
        else { return PartCell() }
        cell.part = viewModel.parts[indexPath.row]
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = viewModel.parts[indexPath.row]
        
        return [item]
    }
    
    func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        viewModel.dragAndDrop(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        dragPreviewParametersForRowAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? PartCell else { return nil }
        let param = UIDragPreviewParameters()
        param.visiblePath = UIBezierPath(roundedRect: CGRect(
            x: 16,
            y: 22,
            width: selectedCell.container.frame.width,
            height: selectedCell.container.frame.height
        ), cornerRadius: 10)
        return param
    }
    
    func tableView(
        _ tableView: UITableView,
        dropPreviewParametersForRowAt indexPath: IndexPath
    ) -> UIDragPreviewParameters? {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? PartCell else { return nil }
        let param = UIDragPreviewParameters()
        param.visiblePath = UIBezierPath(roundedRect: CGRect(
            x: 16,
            y: 22,
            width: selectedCell.container.frame.width,
            height: selectedCell.container.frame.height
        ), cornerRadius: 10)
        
        return param
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        let duplicate: UIAction = UIAction(
            title: "Duplicate",
            image: UIImage(systemName: "doc.on.doc")
        ) { [weak self] _ in
            self?.viewModel.duplicatePart(index: indexPath)
            tableView.reloadData()
        }
        
        let delete: UIAction = UIAction(
            title: "Delete",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [weak self] _ in
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
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil
        ) { _ in
            return UIMenu(children: [duplicate, delete])
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func tableView(
        _ tableView: UITableView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let part = viewModel.parts[indexPath.row]
        editPart(part: part)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CompositionHeader.reuseIdentifier)

        guard let header = header as? CompositionHeader else { return header }

        header.versionName = viewModel.name.capitalized

        return header
    }
    
    private func makeTargetedPreview(
        for configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil }
        guard let selectedCell = partView?.tableView.cellForRow(at: indexPath) as? PartCell else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: selectedCell.container, parameters: parameters)
    }
    
}
