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
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screen?.recorderView.recorderButton.addAction(
            getActionFromFunction { [weak self] in
                switch self?.viewModel.audioManager.audioControlState {
                case .recording:
                    self?.viewModel.stopRecording()
                case .preparedToRecord:
                    self?.viewModel.startRecording()
                default: return
                }
            }, for: .touchUpInside
        )
        
        screen?.recorderView.playButton.addAction(
            getActionFromFunction { [weak self] in
                switch self?.viewModel.audioManager.audioControlState {
                case .recording:
                    self?.viewModel.stopRecording()
                case .playing:
                    self?.viewModel.pauseAudio()
                case .pausedPlaying:
                    self?.viewModel.resumeAudio()
                default: return
                }
            }, for: .touchUpInside
        )
        
        screen?.recorderView.trashButton.addAction(
            getActionFromFunction(function: viewModel.deleteAudio), for: .touchUpInside
        )
        
        viewModel.audioManager.delegete = self
    }
    
    override func loadView() {
        super.loadView()
        self.screen = LyricsEditingScreenView(keyboardListener: self)
        self.view = screen
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.prepareToExit()
    }
    
    @objc
    func actionTrash() {
        let title = "Do you want to delete this record?"
        let message = "The record will be deleted and you will not be able to recover it."
        
        let alert = Alert(title: title,
                          message: message,
                          actionButtonLabel: "Delete",
                          actionButtonStyle: .destructive,
                          preferredStyle: .alert) {
            self.viewModel.deleteAudio()
            self.screen?.recorderView.audioDeleted()
        }
        
        present(alert, animated: false)
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
    
    private func getActionFromFunction(function: @escaping () -> Void) -> UIAction {
        return UIAction { _ in function() }
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
        viewModel.saveLyricsEdition(completion: nil)
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
