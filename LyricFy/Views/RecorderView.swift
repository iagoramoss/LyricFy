//
//  RecorderView.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 09/05/23.
//

import UIKit

class RecorderView: UIView {

    private var pulseLayers = [CAShapeLayer]()
    private var imgView = UIImageView()

    lazy var labelRecording: UILabel = {
        let label = UILabel()
        label.text = "Recording"
        label.textAlignment = .center
        label.isHidden = true
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()

    lazy var labelPlay: UILabel = {
        let label = UILabel()
        label.text = "Record"
        label.textAlignment = .left
        label.isHidden = true
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    lazy var labelTimer: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textAlignment = .center
        label.isHidden = true
        label.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    lazy var recorderButton: UIButton = {
        let button = UIButton()
        return button
    }()

    lazy var circleLayer: CAShapeLayer = {
        let pulseLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: UIScreen.main.bounds.size.width / 13.0,
                                        startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        pulseLayer.path = circularPath.cgPath
        pulseLayer.lineWidth = 3.0
        pulseLayer.fillColor = UIColor.clear.cgColor
        pulseLayer.strokeColor = UIColor.gray.cgColor
        pulseLayer.lineCap = CAShapeLayerLineCap.round
        pulseLayer.position = CGPoint(x: UIScreen.main.bounds.size.width / 30.0,
                                      y: UIScreen.main.bounds.size.height / 35.0)

        return pulseLayer
    }()

    lazy var playButton: UIButton = {
        let play = UIButton()
        play.setImage(UIImage(systemName: "play.fill"), for: .normal)
        play.tintColor = .white
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

    func createPulse() {
        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero,
                                            radius: UIScreen.main.bounds.size.width / 12.0,
                                            startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 3.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: UIScreen.main.bounds.size.width / 30.0,
                                          y: UIScreen.main.bounds.size.height / 35.0)
            pulseLayer.zPosition = recorderButton.layer.zPosition - 1
            recorderButton.layer.addSublayer(pulseLayer)
            pulseLayers.append(pulseLayer)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animatePulse(index: 1)
            }
        }
    }
    func disablePulse() {
        pulseLayers.forEach { $0.removeFromSuperlayer() }
        pulseLayers.removeAll()
    }

    func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.red.cgColor

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.8
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.8
        opacityAnimation.toValue = 0.3
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }

    func audioDeleted() {
        playButton.isHidden = true
        trashButton.isHidden = true
        recorderButton.isHidden = false
        labelPlay.isHidden = true
        self.disablePulse()
    }
    
    func audioSatateChanged(state: AudioState) {
        switch state {
        case .recording:
            labelRecording.isHidden = false
            labelTimer.isHidden = false

            recorderButton.subviews.forEach { $0.removeFromSuperview() }
            imgView = UIImageView(image: UIImage(systemName: "square.fill"))
            imgView.frame.size = .init(width: 35, height: 35)
            imgView.layer.position = .init(x: UIScreen.main.bounds.size.width / 30.0,
                                           y: UIScreen.main.bounds.size.height / 35.0)
            imgView.tintColor = .red
            recorderButton.addSubview(imgView)
            self.createPulse()
            
        case .preparedToRecord:
            playButton.isHidden = true
            trashButton.isHidden = true

            recorderButton.subviews.forEach { $0.removeFromSuperview() }
            imgView = UIImageView(image: UIImage(systemName: "circle.fill"))
            imgView.frame.size = .init(width: 50, height: 50)
            imgView.layer.position = .init(x: UIScreen.main.bounds.size.width / 30.0,
                                           y: UIScreen.main.bounds.size.height / 35.0)
            imgView.tintColor = .red
            recorderButton.addSubview(imgView)

            recorderButton.isHidden = false
            labelPlay.isHidden = true
            
        case .preparedToPlay:
            labelTimer.isHidden = true
            labelPlay.isHidden = false
            playButton.isHidden = false
            trashButton.isHidden = false
            labelRecording.isHidden = true
            recorderButton.isHidden = true
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
        self.addSubview(recorderButton)
        self.addSubview(labelRecording)
        self.addSubview(labelTimer)
        self.addSubview(playButton)
        self.addSubview(trashButton)
        self.addSubview(labelPlay)
        self.recorderButton.layer.addSublayer(circleLayer)
    }

    func setupConstraints() {
        labelPlay.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        labelRecording.translatesAutoresizingMaskIntoConstraints = false
        recorderButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelRecording.bottomAnchor.constraint(equalTo: recorderButton.topAnchor, constant: -60),
            labelRecording.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            labelTimer.bottomAnchor.constraint(equalTo: recorderButton.topAnchor, constant: -30),
            labelTimer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            labelPlay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            labelPlay.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            trashButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            trashButton.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            recorderButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80),
            recorderButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        self.backgroundColor = .colors(name: .buttonsColor)
    }
}
