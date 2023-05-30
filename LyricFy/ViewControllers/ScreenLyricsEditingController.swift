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
    
    private var viewModel: ScreenLyricsEditingViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    private weak var delegate: PartDelegate?
    
    init(viewModel: ScreenLyricsEditingViewModel, delegate: PartDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        viewModel.delegete = self
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        self.screen = LyricsEditingScreenView(keyboardListener: self)
        self.view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen?.recorderView.recorderButton.addTarget(self,
                                                      action: #selector(recordAndStopAction),
                                                      for: .touchUpInside)
        
        screen?.playerView.playAndPauseButton.addTarget(self,
                                                        action: #selector(playAndPauseAction),
                                                        for: .touchUpInside)
        
        screen?.playerView.trashButton.addTarget(self,
                                                 action: #selector(deleteAudioAction),
                                                 for: .touchUpInside)
        
        screen?.placeHolder.isHidden = viewModel.lyricsText.isEmpty ? false : true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopTasks()
    }
    
    // MARK: - View Actions
    @objc
    func playAndPauseAction() {
        switch viewModel.audioState {
        case .preparedToPlay:
            viewModel.playAudio()
        case .playing:
            viewModel.pauseAudio()
        case .pausedPlaying:
            viewModel.resumeAudio()
        default: return
        }
    }
    
    @objc
    func recordAndStopAction() {
        switch viewModel.audioState {
        case .recording:
            viewModel.stopRecording()
        case .preparedToRecord:
            viewModel.startRecording()
        default: return
        }
    }
    
    @objc
    func deleteAudioAction() {
        let title = "Do you want to delete this record?"
        let message = "The record will be deleted and you will not be able to recover it."
        
        let alert = Alert(title: title,
                          message: message,
                          actionButtonLabel: "Delete",
                          actionButtonStyle: .destructive,
                          preferredStyle: .alert) {
            self.viewModel.deleteAudio()
        }
        
        present(alert, animated: false)
    }
    
    // MARK: - Setup ViewController
    private func setupView() {
        setupNavigationBar()
        setupBindings()
        screen?.textView.text = viewModel.lyricsText
    }
    
    private func setupBindings() {
        screen?.textView.delegate = self
        
        screen?.textView.textPublisher
            .assign(to: \.lyricsText, on: self.viewModel)
            .store(in: &subscriptions)
        
        viewModel.$audioState
            .sink { self.screen?.setupAudioView(state: $0) }
            .store(in: &subscriptions)
        
        viewModel.$recordingTimeLabel
            .sink { self.screen?.recorderView.labelTimer.text = $0 ?? "00:00" }
            .store(in: &subscriptions)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.lyricsType
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .colors(name: .barButtonColor)
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
        
        if !textView.text.isEmpty {
            screen?.placeHolder.isHidden = true
        } else {
            screen?.placeHolder.isHidden = false
        }
        
        guard let textView = screen?.textView else { return }
        
        let newSize = textView.sizeThatFits(
            CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size.height = newSize.height
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.saveLyricsEdition(completion: delegate?.reloadData)
    }
}

extension ScreenLyricsEditingController: AudioPermissionAlertDelegate {
    
    func presetAudioPermissionDeniedAlert() {
        let message = "Please, go on Settings > Privacy > Microphone to allow audio recording permssion."
        let title = "No Recording Permission"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: { print($0) }))
        
        present(alert, animated: false)
    }
}

extension ScreenLyricsEditingController: KeyboardListener {
    
    func keyboardWillAppear() {
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(doneClicked))
        doneButton.tintColor = .colors(name: .sheetButtonColor)
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
