//
//  RecorderView.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 09/05/23.
//

import UIKit

class RecorderView: UIView {

    lazy var labelRecording: UILabel = {
        let label = UILabel()
        label.text = "Recording"
        label.textAlignment = .center
        label.isHidden = true
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()

    lazy var labelPlay: UILabel = {
        let label = UILabel()
        label.text = "Record 01"
        label.textAlignment = .left
        label.isHidden = true
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    lazy var labelTimer: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textAlignment = .center
        label.isHidden = true
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()

    lazy var recorderButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.backgroundColor = .red
        return button
    }()
    
    lazy var playButton: UIButton = {
        let play = UIButton()
        play.setImage(UIImage(systemName: "play.fill"), for: .normal)
        play.tintColor = .black
        play.isHidden = true
        return play
    }()

    lazy var trashButton: UIButton = {
        let trash = UIButton()
        trash.setImage(UIImage(systemName: "trash"), for: .normal)
        trash.tintColor = .red
        trash.isHidden = true
        return trash
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    func audioDeleted() {
        playButton.isHidden = true
        trashButton.isHidden = true
        recorderButton.layer.cornerRadius = 30
        recorderButton.backgroundColor = .red
        recorderButton.isHidden = false
        labelPlay.isHidden = true
    }
    
    func audioSatateChanged(state: AudioState) {
        switch state {
        case .recording:
            labelRecording.isHidden = false
            labelTimer.isHidden = false
            recorderButton.layer.cornerRadius = 10
            recorderButton.backgroundColor = .yellow
            
        case .preparedToRecord:
            playButton.isHidden = true
            trashButton.isHidden = true
            recorderButton.layer.cornerRadius = 30
            recorderButton.backgroundColor = .red
            recorderButton.isHidden = false
            labelPlay.isHidden = true
            
        case .preparedToPlay:
            labelRecording.isHidden = true
            labelTimer.isHidden = true
            recorderButton.isHidden = true
            labelPlay.isHidden = false
            playButton.isHidden = false
            trashButton.isHidden = false
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        case .pausedPlaying:
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            
        case .playing:
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecorderView: ViewCode {

    func setupHierarchy() {
        addSubview(recorderButton)
        addSubview(labelRecording)
        addSubview(labelTimer)
        addSubview(playButton)
        addSubview(trashButton)
        addSubview(labelPlay)
    }

    func setupConstraints() {
        labelRecording.translatesAutoresizingMaskIntoConstraints = false
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        labelPlay.translatesAutoresizingMaskIntoConstraints = false
        recorderButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelRecording.bottomAnchor.constraint(equalTo: recorderButton.topAnchor, constant: -30),
            labelRecording.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            labelTimer.bottomAnchor.constraint(equalTo: recorderButton.topAnchor, constant: 0),
            labelTimer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            labelPlay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelPlay.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            trashButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            trashButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),

            recorderButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            recorderButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            recorderButton.widthAnchor.constraint(equalToConstant: 65),
            recorderButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .systemGray
    }
}
