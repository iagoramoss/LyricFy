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
        self.screen = LyricsEditingScreenView(keyboardListener: self)
        self.view = screen
    }

    init(viewModel: ScreenLyricsEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        screen?.recorderView.recorderButton.addTarget(self, action: #selector(actionRecordButton), for: .touchUpInside)
        screen?.recorderView.playButton.addTarget(self, action: #selector(actionPlay), for: .touchUpInside)
        screen?.recorderView.trashButton.addTarget(self, action: #selector(actionTrash), for: .touchUpInside)
    }

    @objc
    func actionRecordButton() {
        viewModel?.buttonTapCount += 1

        switch viewModel?.buttonTapCount {
        case 1:
            screen?.recorderView.labelRecording.isHidden = false
            screen?.recorderView.labelTimer.isHidden = false
            screen?.recorderView.recorderButton.layer.cornerRadius = 10
            screen?.recorderView.recorderButton.backgroundColor = .yellow
        default:
            screen?.recorderView.labelRecording.isHidden = true
            screen?.recorderView.labelTimer.isHidden = true
            screen?.recorderView.recorderButton.isHidden = true
            screen?.recorderView.labelPlay.isHidden = false
            screen?.recorderView.playButton.isHidden = false
            screen?.recorderView.trashButton.isHidden = false
            viewModel?.buttonTapCount = 0
        }
    }

    @objc
    func actionPlay() {
        viewModel?.buttonPlayCount += 1

        switch viewModel?.buttonPlayCount {
        case 1:
            screen?.recorderView.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        default:
            screen?.recorderView.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            viewModel?.buttonPlayCount = 0
        }
    }

    @objc
    func actionTrash() {
        screen?.recorderView.playButton.isHidden = true
        screen?.recorderView.trashButton.isHidden = true
        screen?.recorderView.recorderButton.layer.cornerRadius = 30
        screen?.recorderView.recorderButton.backgroundColor = .red
        screen?.recorderView.recorderButton.isHidden = false
        screen?.recorderView.labelPlay.isHidden = true
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
        navigationController?.navigationBar.tintColor = .black
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
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

extension ScreenLyricsEditingController: KeyboardListener {
    
    func keyboardWillAppear() {
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneClicked))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func keyboardWillhide() {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc
    func doneClicked(_ sender: Any) {
        view.endEditing(true)
    }
}
