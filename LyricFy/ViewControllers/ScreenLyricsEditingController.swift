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
    
    init(viewModel: ScreenLyricsEditingViewModel) {
        self.viewModel = viewModel
        self.viewModel.audioManager.prepareViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.recorderView.recorderButton.addTarget(self,
                                                      action: #selector(actionRecord),
                                                      for: .touchUpInside)
        screen?.recorderView.playButton.addTarget(self,
                                                  action: #selector(actionPlay),
                                                  for: .touchUpInside)
        screen?.recorderView.trashButton.addTarget(self,
                                                   action: #selector(actionTrash),
                                                   for: .touchUpInside)
        viewModel.audioManager.delegete = self
        
        screen?.placeHolder.isHidden = viewModel.lyricsText.isEmpty ? false : true
    }
    
    override func loadView() {
        super.loadView()
        self.screen = LyricsEditingScreenView(keyboardListener: self)
        self.view = screen
    }
    
    @objc
    func actionRecord() {
        viewModel.audioManager.startRecording()
    }
    
    @objc
    func actionStopRecord() {
        viewModel.audioManager.stopRecording()
    }
    
    @objc
    func actionPlay() {
        viewModel.audioManager.playAudio()
    }

    @objc
    func actionPause() {
        viewModel.audioManager.pauseAudio()
    }
    
    @objc
    func actionTrash() {
        let title = "Do you want to delete this record?"
        let message = "The record will be deleted and you will not be able to recover it."
        
        let alert = Alert(title: title,
                          message: message,
                          actionButtonLabel: "Delete",
                          actionButtonStyle: .destructive,
                          preferredStyle: .alert) { [weak self] in
            self?.viewModel.audioManager.deleteAudio()
            self?.screen?.recorderView.audioDeleted()
        }
        
        present(alert, animated: false)
    }
    
    private func audioStateChanged(state: AudioState) {
        switch state {
        case .recording:
            screen?.recorderView.labelRecording.isHidden = false
            screen?.recorderView.labelTimer.isHidden = false
            screen?.recorderView.recorderButton.layer.cornerRadius = 10
            screen?.recorderView.recorderButton.backgroundColor = .red
            screen?.recorderView.recorderButton.addTarget(self,
                                                          action: #selector(actionStopRecord),
                                                          for: .touchUpInside)
            
        case .preparedToRecord:
            screen?.recorderView.playButton.isHidden = true
            screen?.recorderView.trashButton.isHidden = true
            screen?.recorderView.recorderButton.layer.cornerRadius = 25
            screen?.recorderView.recorderButton.backgroundColor = .red
            screen?.recorderView.recorderButton.isHidden = false
            screen?.recorderView.labelPlay.isHidden = true
            screen?.recorderView.recorderButton.addTarget(self,
                                                          action: #selector(actionRecord),
                                                          for: .touchUpInside)
            
        case .preparedToPlay:
            screen?.recorderView.playButton.addTarget(self,
                                                      action: #selector(actionPlay),
                                                      for: .touchUpInside)
            
        case .pausedPlaying:
            screen?.recorderView.playButton.addTarget(self,
                                                      action: #selector(actionPlay),
                                                      for: .touchUpInside)
            
        case .playing:
            screen?.recorderView.playButton.addTarget(self,
                                                      action: #selector(actionPause),
                                                      for: .touchUpInside)
        }
    }
    
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
        
        viewModel.audioManager.$audioControlState
            .sink { state in
                self.audioStateChanged(state: state)
                self.screen?.recorderView.audioSatateChanged(state: state)
            }
            .store(in: &subscriptions)
        
        viewModel.audioManager.$recordingTimeLabel
            .sink { counterLabel in
                self.screen?.recorderView.labelTimer.text = counterLabel ?? "00:00:00"
            }
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
        viewModel.saveLyricsEdition()
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
