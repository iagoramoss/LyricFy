//
//  ScreenLyricsEditingController.swift
//  LyricFy
//
//  Created by Afonso Lucas on 28/04/23.
//

import UIKit

class ScreenLyricsEditingController: UIViewController {

    private var screen: LyricsEditingScreenView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    override func loadView() {
        super.loadView()
        self.screen = LyricsEditingScreenView()
        self.view = screen
    }

    func setupNavigationBar() {
        navigationItem.title = "Intro"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
