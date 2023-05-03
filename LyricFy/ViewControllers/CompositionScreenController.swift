//
//  CompositionScreenController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit

class CompositionScreenController: UIViewController {

    var compositionView = CompositionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = compositionView

        NotificationCenter.default.addObserver(self, selector: #selector(onTappedButtonAdd),
                                               name: .init(rawValue: "tappedButton"), object: nil)

        let addButton = UIBarButtonItem(image: .init(systemName: "plus"),
                                        style: .plain, target: self,
                                        action: #selector(tappedButtonAdd))
        addButton.tintColor = .black

        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"))

        menuButton.menu = addMenuItems()
        menuButton.tintColor = .black
        navigationItem.rightBarButtonItems = [addButton, menuButton]
    }

    @objc
    func tappedButtonAdd() {
        print("NOTIFICACAO ENVIADAAA")
        NotificationCenter.default.post(.init(name: Notification.Name(rawValue: "tappedButton")))
    }

    @objc
    func onTappedButtonAdd() {
        print("NOTIFICACAO RECEBIDAAA")
        let contentVC = SheetViewController()
        let sheetController = contentVC.sheetPresentationController
        sheetController?.preferredCornerRadius = 10
        sheetController?.detents = [.medium()]
        sheetController?.prefersGrabberVisible = true
        present(contentVC, animated: true, completion: nil)
    }

    func addMenuItems() -> UIMenu {
        let menu = UIMenu(title: "UIMenu", children: [
            UIAction(title: "Create Version", image: UIImage(systemName: "plus"), state: .off) { _ in
                print("CREATE VERSION")
            },
            UIAction(title: "Delete Version",
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive,
                     state: .off) { _ in
                print("DELETE VERSION")
            }
        ])
        return menu
    }
}
