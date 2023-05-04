//
//  ScreenLyricsEditingController.swift
//  LyricFy
//
//  Created by Afonso Lucas on 28/04/23.
//

import UIKit
import Combine

class ScreenLyricsEditingController: UIViewController {
    
    private var screen: LyricsEditingScreenView? { didSet { setupView() } }
    
    private var viewModel: ScreenLyricsEditingViewModel?
    
    private var subscriptions = Set<AnyCancellable>()
    
    override func loadView() {
        super.loadView()
        self.screen = LyricsEditingScreenView()
        self.view = screen
    }
    
    init(viewModel: ScreenLyricsEditingViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    func setupViewModel(viewModel: ScreenLyricsEditingViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupView() {
        setupNavigationBar()
        setupBindings()
        screen?.textView.text = viewModel?.lyricsText
    }
    
    private func setupBindings() {
        screen?.textView.delegate = self
        screen?.textView.textPublisher
            .assign(to: \.lyricsText, on: self.viewModel!)
            .store(in: &subscriptions)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel?.lyricsType
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
        required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel?.saveLyricsEdition()
    }
}
