//
//  LyricsEditingScreenView.swift
//  LyricFy
//
//  Created by Afonso Lucas on 28/04/23.
//

import Foundation
import UIKit

class LyricsEditingScreenView: UIView, ViewCode {

    lazy var recorderView = RecorderView()
    
    lazy var playerView = PlayerView()

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = true
        view.alwaysBounceVertical = true
        view.bouncesZoom = true
        view.minimumZoomScale = 1
        view.maximumZoomScale = 1
        view.backgroundColor = .colors(name: .sectionsColor)
        view.keyboardDismissMode = .onDrag
        return view
    }()

    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .clear
        return view
    }()

    lazy var placeHolder: UILabel = {
        let view = UILabel()
        view.text = "Type something here..."
        view.font = .systemFont(ofSize: 18)
        view.textColor = UIColor.lightGray
        return view
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .automatic
        view.isEditable = true
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = .colors(name: .barButtonColor)
        view.textAlignment = .left
        view.backgroundColor = .clear
        view.typingAttributes = NSAttributedString.defaultParagraphAttributes
        return view
    }()

    let keyboardListenerDelegate: KeyboardListener

    init(keyboardListener: KeyboardListener) {
        self.keyboardListenerDelegate = keyboardListener
        super.init(frame: .zero)
        setupView()
    }
    
    func setupAudioView(state: AudioState) {
        
        recorderView.audioSatateChanged(state: state)
        
        switch state {
        case .recording, .preparedToRecord:
            recorderView.isHidden = false
            playerView.isHidden = true
        case .preparedToPlay, .pausedPlaying, .playing:
            recorderView.isHidden = true
            playerView.isHidden = false
        }
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .clear
        configureKeyboardNotifications()
    }

    func setupHierarchy() {
        textView.addSubview(placeHolder)
        contentView.addSubview(textView)
        scrollView.addSubview(contentView)
        addSubview(scrollView)
        addSubview(recorderView)
        addSubview(playerView)
    }

    func setupConstraints() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        recorderView.translatesAutoresizingMaskIntoConstraints = false
        placeHolder.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: .screenWidth),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: .screenWidth - 32),

            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: .screenHeight/3),
            
            placeHolder.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeHolder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),

            recorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            recorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            recorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            recorderView.heightAnchor.constraint(equalToConstant: 180),
            
            playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }

    private func configureKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboradWillShow),
                                       name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LyricsEditingScreenView {

    @objc
    func keyboradWillShow(notification: Notification) {
        guard let keyboardValue: NSValue =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardFrame = keyboardValue.cgRectValue
        let keyboardConvertedFrame = convert(keyboardFrame, to: window)

        scrollView.contentInset.bottom = keyboardConvertedFrame.size.height
        keyboardListenerDelegate.keyboardWillAppear()
    }

    @objc
    func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.contentInset = UIEdgeInsets.zero
        keyboardListenerDelegate.keyboardWillhide()
    }
}
