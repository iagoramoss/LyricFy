//
//  PlayerView.swift
//  LyricFy
//
//  Created by Afonso Lucas on 26/05/23.
//

import UIKit

class PlayerView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Record"
        return label
    }()
    
    lazy var trashButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    lazy var musicSlider: UISlider = {
        let slider = UISlider()
        let frame = CGRect(x: 0, y: 0, width: 9, height: 9)
        let circle: UIView = SliderThumb(fill: .red, frame: frame)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.isContinuous = false
        slider.tintColor = .white
        slider.setThumbImage(circle.asImage(), for: .normal)
        return slider
    }()
    
    lazy var musicPastTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "0:00"
        return label
    }()
    
    lazy var musicMissingTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "0:00"
        return label
    }()
    
    lazy var playAndPauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerView: ViewCode {
    
    func setupAdditionalConfiguration() {
        backgroundColor = .colors(name: .recorderColor)
    }
    
    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(trashButton)
        addSubview(musicSlider)
        addSubview(playAndPauseButton)
        addSubview(musicPastTimeLabel)
        addSubview(musicMissingTimeLabel)
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        musicSlider.translatesAutoresizingMaskIntoConstraints = false
        playAndPauseButton.translatesAutoresizingMaskIntoConstraints = false
        musicPastTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        musicMissingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 34),
            
            trashButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            trashButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            trashButton.widthAnchor.constraint(equalToConstant: 19),
            
            musicSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            musicSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            musicSlider.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 34),
            
            musicPastTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            musicPastTimeLabel.topAnchor.constraint(equalTo: musicSlider.bottomAnchor, constant: 8),
            
            musicMissingTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            musicMissingTimeLabel.topAnchor.constraint(equalTo: musicSlider.bottomAnchor, constant: 8),
            
            playAndPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playAndPauseButton.topAnchor.constraint(equalTo: musicSlider.bottomAnchor, constant: 28),
            playAndPauseButton.heightAnchor.constraint(equalToConstant: 27)
        ])
    }
}
