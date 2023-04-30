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
        setupBindings()
    }

    override func loadView() {
        super.loadView()
        self.screen = LyricsEditingScreenView()
        self.view = screen
    }

    func setupBindings() {
        screen?.textView.delegate = self
    }

    func setupNavigationBar() {
        navigationItem.title = "Intro"
        navigationController?.navigationBar.prefersLargeTitles = false
    }

}

extension ScreenLyricsEditingController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        screen?.textView.becomeFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let textView = screen?.textView else { return }

        let newSize = textView.sizeThatFits(
            CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size.height = newSize.height
    }
}
