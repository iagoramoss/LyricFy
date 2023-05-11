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
        label.text = "00:00"
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecorderView: ViewCode {

    func setupHierarchy() {
        self.addSubview(recorderButton)
        self.addSubview(labelRecording)
        self.addSubview(labelTimer)
        self.addSubview(playButton)
        self.addSubview(trashButton)
        self.addSubview(labelPlay)
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
            labelRecording.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            labelTimer.bottomAnchor.constraint(equalTo: recorderButton.topAnchor, constant: 0),
            labelTimer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            labelPlay.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            labelPlay.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            
            playButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            trashButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            trashButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),

            recorderButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            recorderButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            recorderButton.widthAnchor.constraint(equalToConstant: 65),
            recorderButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }

    func setupAdditionalConfiguration() {
        self.backgroundColor = .systemGray
    }

}