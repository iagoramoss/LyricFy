//
//  HomeViewController.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeViewController: UIViewController {
    var screen = HomeView()
    
//    lazy var alert: UIAlertController = {
//        let alert = UIAlertController(title: "Delete", message: "This project will be deleted. And it will not be possible to recover it.", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .destructive, handler: { _ in
//        NSLog("The \"OK\" alert occured.")
//        }))
//        return alert
//    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = screen
        self.view.backgroundColor = .white
        title = "Projects"
        navigationController?.navigationBar.prefersLargeTitles = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(escreverTextoNoTerminal),
                                               name: .init(rawValue: "emptyView"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(excluirProjeto),
                                               name: .init(rawValue: "excluir"),
                                               object: nil)
    }
    @objc
    func escreverTextoNoTerminal() {
        print("Você apertou o botão!")
        navigationController?.pushViewController(CompositionScreenController(), animated: true)
    }
    @objc
    func excluirProjeto() {
        print("Você apertou o botão excluir!")
        self.present(screen.alert, animated: true, completion: nil)
    }
}
