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

    init() {
        super.init(frame: .zero)
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
    
    func audioSatateChanged(state: AudioState) {
        switch state {
        case .recording:
            recorderButton.subviews.forEach { $0.removeFromSuperview() }
            imgView = UIImageView(image: UIImage(systemName: "square.fill"))
            imgView.frame.size = .init(width: 35, height: 35)
            imgView.layer.position = .init(x: UIScreen.main.bounds.size.width / 30.0,
                                           y: UIScreen.main.bounds.size.height / 35.0)
            imgView.tintColor = .red
            recorderButton.addSubview(imgView)
            createPulse()
            
        case .preparedToRecord:
            recorderButton.subviews.forEach { $0.removeFromSuperview() }
            imgView = UIImageView(image: UIImage(systemName: "circle.fill"))
            imgView.frame.size = .init(width: 50, height: 50)
            imgView.layer.position = .init(x: UIScreen.main.bounds.size.width / 30.0,
                                           y: UIScreen.main.bounds.size.height / 35.0)
            imgView.tintColor = .red
            recorderButton.addSubview(imgView)
            
        default: return
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
        recorderButton.layer.addSublayer(circleLayer)
    }

    func setupConstraints() {
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        labelRecording.translatesAutoresizingMaskIntoConstraints = false
        recorderButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelRecording.bottomAnchor.constraint(equalTo: recorderButton.topAnchor, constant: -60),
            labelRecording.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            labelTimer.bottomAnchor.constraint(equalTo: recorderButton.topAnchor, constant: -30),
            labelTimer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            recorderButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80),
            recorderButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func setupAdditionalConfiguration() {
        backgroundColor = .colors(name: .recorderColor)
    }
}
