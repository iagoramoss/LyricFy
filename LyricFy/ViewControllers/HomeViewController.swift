//
//  HomeViewController.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeViewController: UIViewController {
    var screen = HomeView()
    
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

    }
    @objc
    func escreverTextoNoTerminal() {
        print("Você apertou o botão!")
        navigationController?.pushViewController(CompositionScreenController(), animated: true)
    }
}
