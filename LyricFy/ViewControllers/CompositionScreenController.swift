//
//  CompositionScreenController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit

class CompositionScreenController: UIViewController {
    var songStructures: [SongStructure] = SongStructure.mock
    var versions: [String] = ["versao 1", "versao 2", "versao 3", "versao 4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view = SongStructureView(delegate: self)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let menu = UIMenu(children: [
            UIAction(
                title: "Change version",
                image: UIImage(systemName: "arrow.triangle.branch"),
                state: .off) { [weak self] _ in
                self?.onTappedButtonVersion()
            },
            UIAction(title: "Duplicate version",
                     image: UIImage(systemName: "doc.on.doc"),
                     state: .off) { [weak self] _ in
                self?.versions.append("teste")
            },
            UIAction(title: "Delete version",
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive,
                     state: .off) { [weak self] _ in
                self?.versions.removeLast()
            }
        ])
        
        let addButton = UIBarButtonItem(image: .init(systemName: "plus"), style: .plain,
        target: self, action: #selector(onTappedButtonAdd))
        addButton.tintColor = .colors(name: .barButtonColor)

        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))
        menuButton.menu = menu
        menuButton.tintColor = .colors(name: .barButtonColor)

        navigationItem.title = "Song"
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.colors(name: .buttonsColor)!
        ]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItems = [addButton, menuButton]
    }

    @objc
    func onTappedButtonAdd() {
        let sheetVC = SheetViewController()
        sheetVC.modalPresentationStyle = .pageSheet
        sheetVC.sheetPresentationController?.detents = [.medium()]
        sheetVC.sheetPresentationController?.prefersGrabberVisible = true
        present(sheetVC, animated: true)
    }

    @objc
    func onTappedButtonVersion() {
        let versionsVC = VersionsViewController(versions: versions)
        versionsVC.modalPresentationStyle = .pageSheet
        versionsVC.sheetPresentationController?.detents = [.medium()]
        versionsVC.sheetPresentationController?.prefersGrabberVisible = true
        present(versionsVC, animated: true)
    }
}

extension CompositionScreenController: SongStructureTableView {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return songStructures.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongStructure.reuseIdentifier,
                                                       for: indexPath) as? SongStructureCell
        else { return SongStructureCell() }
        
        cell.songStructure = songStructures[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = songStructures[indexPath.row]
        
        return [item]
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        let cell = songStructures.remove(at: sourceIndexPath.row)
        songStructures.insert(cell, at: destinationIndexPath.row)
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
                    
                    self.songStructures.insert(self.songStructures[indexPath.row], at: indexPath.row)
                    tableView.reloadData()
                },
                UIAction(title: "Delete", attributes: .destructive) {[weak self] _ in
                    self?.present(
                        Alert(title: "",
                              message: "This section will be deleted. And it will not be possible to recover it.",
                              actionButtonLabel: "Delete",
                              actionButtonStyle: .destructive,
                              preferredStyle: .actionSheet) { [weak self] in
                                  
                                self?.songStructures.remove(at: indexPath.row)
                                tableView.reloadData()
                    }, animated: true)
                }
            ])
        }
    }
}
