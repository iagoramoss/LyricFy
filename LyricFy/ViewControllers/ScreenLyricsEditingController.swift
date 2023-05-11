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
    
    private var buttonTapCount = 0
    private var buttonPlayCount = 0

    override func loadView() {
        super.loadView()
        self.screen = LyricsEditingScreenView(keyboardListener: self)
        self.view = screen
        NotificationCenter.default.addObserver(self, selector: #selector(actionRecordButton),
        name: .init(rawValue: "tapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionTrash),
        name: .init(rawValue: "tappedTrash"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(actionPlay),
        name: .init(rawValue: "tappedPlay"), object: nil)
        MockRecorder.sharedRecord.audioControlState = .preparedToRecord
    }
    
    init(viewModel: ScreenLyricsEditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @objc
    func actionRecordButton() {
        buttonTapCount += 1

        switch buttonTapCount {
        case 1:
            MockRecorder.sharedRecord.audioControlState = .recording
            screen?.recorderView.labelRecording.isHidden = false
            screen?.recorderView.labelTimer.isHidden = false
            screen?.recorderView.recorderButton.layer.cornerRadius = 10
            screen?.recorderView.recorderButton.backgroundColor = .yellow
        default:
            MockRecorder.sharedRecord.audioControlState = .preparedToPlay
            screen?.recorderView.labelRecording.isHidden = true
            screen?.recorderView.labelTimer.isHidden = true
            screen?.recorderView.recorderButton.isHidden = true
            screen?.recorderView.labelPlay.isHidden = false
            screen?.recorderView.playButton.isHidden = false
            screen?.recorderView.trashButton.isHidden = false
            buttonTapCount = 0
        }
    }
    @objc
    func actionTrash() {
        MockRecorder.sharedRecord.audioControlState = .preparedToRecord
        screen?.recorderView.playButton.isHidden = true
        screen?.recorderView.trashButton.isHidden = true
        screen?.recorderView.recorderButton.layer.cornerRadius = 30
        screen?.recorderView.recorderButton.backgroundColor = .red
        screen?.recorderView.recorderButton.isHidden = false
        screen?.recorderView.labelPlay.isHidden = true
    }
    @objc
    func actionPlay() {
        buttonPlayCount += 1
        switch buttonPlayCount {
        case 1:
            MockRecorder.sharedRecord.audioControlState = .playing
            screen?.recorderView.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        default:
            MockRecorder.sharedRecord.audioControlState = .pausedPlaying
            screen?.recorderView.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            buttonPlayCount = 0
        }
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

//        UIView.animate(withDuration: 0.5) { [self] in
//            screen?.recorderView.frame = CGRect(x: 0, y: self.view.frame.height,
//            width: self.view.bounds.width, height: self.view.bounds.height + 300)
//            screen?.recorderView.layoutIfNeeded()
//        }
