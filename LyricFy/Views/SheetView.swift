//
//  SheetView.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 02/05/23.
//

import Foundation
import UIKit

class SheetView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    var verse: UIButton = {
        var button = UIButton()
        button.setTitle("Verse", for: .normal)
        button.layer.cornerRadius = 23
        button.setTitleColor(.colors(name: .buttonsLabel), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .colors(name: .buttonsColor)
        return button
    }()
    
    var preChorus: UIButton = {
        var button = UIButton()
        button.setTitle("Pre-Chorus", for: .normal)
        button.layer.cornerRadius = 23
        button.setTitleColor(.colors(name: .buttonsLabel), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .colors(name: .buttonsColor)
        return button
    }()
    
    var chorus: UIButton = {
        var button = UIButton()
        button.setTitle("Chorus", for: .normal)
        button.layer.cornerRadius = 23
        button.setTitleColor(.colors(name: .buttonsLabel), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .colors(name: .buttonsColor)
        return button
    }()
    
    var bridge: UIButton = {
        var button = UIButton()
        button.setTitle("Bridge", for: .normal)
        button.layer.cornerRadius = 23
        button.setTitleColor(.colors(name: .buttonsLabel), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .colors(name: .buttonsColor)
        return button
    }()
    
    var custom: UIButton = {
        var button = UIButton()
        button.setTitle("Custom", for: .normal)
        button.layer.cornerRadius = 23
        button.setTitleColor(.colors(name: .buttonsLabel), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = .colors(name: .buttonsColor)
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SheetView: ViewCode {
    
    func setupHierarchy() {
        addSubview(verse)
        addSubview(preChorus)
        addSubview(chorus)
        addSubview(bridge)
        addSubview(custom)
    }
    
    func setupConstraints() {
        verse.translatesAutoresizingMaskIntoConstraints = false
        preChorus.translatesAutoresizingMaskIntoConstraints = false
        chorus.translatesAutoresizingMaskIntoConstraints = false
        bridge.translatesAutoresizingMaskIntoConstraints = false
        custom.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verse.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            verse.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verse.widthAnchor.constraint(equalToConstant: 85),
            verse.heightAnchor.constraint(equalToConstant: 44),

            preChorus.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            preChorus.leadingAnchor.constraint(equalTo: verse.trailingAnchor, constant: 20),
            preChorus.widthAnchor.constraint(equalToConstant: 112),
            preChorus.heightAnchor.constraint(equalToConstant: 44),

            chorus.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            chorus.leadingAnchor.constraint(equalTo: preChorus.trailingAnchor, constant: 20),
            chorus.widthAnchor.constraint(equalToConstant: 85),
            chorus.heightAnchor.constraint(equalToConstant: 44),

            bridge.topAnchor.constraint(equalTo: verse.bottomAnchor, constant: 30),
            bridge.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            bridge.widthAnchor.constraint(equalToConstant: 85),
            bridge.heightAnchor.constraint(equalToConstant: 44),

            custom.topAnchor.constraint(equalTo: preChorus.bottomAnchor, constant: 30),
            custom.leadingAnchor.constraint(equalTo: bridge.trailingAnchor, constant: 20),
            custom.widthAnchor.constraint(equalToConstant: 85),
            custom.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .colors(name: .sheetColor)
    }
}
