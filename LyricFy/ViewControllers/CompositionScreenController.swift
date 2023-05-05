//
//  CompositionScreenController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit

class CompositionScreenController: UIViewController {

    let compositionView = CompositionView()
    var versions: [String] = ["versao 1", "versao 2", "versao 3", "versao 4"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view = compositionView

        let addButton = UIBarButtonItem(image: .init(systemName: "plus"),
        style: .plain, target: self, action: #selector(onTappedButtonAdd))
        addButton.tintColor = .black

        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))
        menuButton.menu = addMenuItems()
        menuButton.tintColor = .black

        let versionButton = UIBarButtonItem(image: .init(systemName: "rectangle.and.pencil.and.ellipsis"),
        style: .plain, target: self, action: #selector(onTappedButtonVersion))
        versionButton.tintColor = .black

        navigationItem.rightBarButtonItems = [addButton, menuButton, versionButton]
    }

    @objc
    func onTappedButtonAdd() {
        let sheetVC = SheetViewController()
        sheetVC.modalPresentationStyle = .pageSheet
        sheetVC.sheetPresentationController?.detents = [.medium()]
        sheetVC.sheetPresentationController?.prefersGrabberVisible = true
        present(sheetVC, animated: true, completion: nil)
    }

    @objc
    func onTappedButtonVersion() {
        let versionsVC = VersionsViewController(versions: versions)
        versionsVC.modalPresentationStyle = .pageSheet
        versionsVC.sheetPresentationController?.detents = [.medium()]
        versionsVC.sheetPresentationController?.prefersGrabberVisible = true
        present(versionsVC, animated: true, completion: nil)
    }

    func addMenuItems() -> UIMenu {
        let menu = UIMenu(children: [
            UIAction(title: "Create Version", image: UIImage(systemName: "plus"), state: .off) { [weak self] _ in
                self?.versions.append("teste")
            },

            UIAction(title: "Delete Version", image: UIImage(systemName: "trash"), attributes: .destructive,
            state: .off) { [weak self] _ in
                self?.versions.removeLast()
            }

        ])
        return menu
    }
}
