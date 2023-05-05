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
    
    var verso: UIButton = {
        var button = UIButton()
        button.setTitle("Verso", for: .normal)
        button.layer.cornerRadius = 15
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    var preRefrao: UIButton = {
        var button = UIButton()
        button.setTitle("Pre Refrão", for: .normal)
        button.layer.cornerRadius = 15
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    var refrao: UIButton = {
        var button = UIButton()
        button.setTitle("Refrão", for: .normal)
        button.layer.cornerRadius = 15
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    var ponte: UIButton = {
        var button = UIButton()
        button.setTitle("Ponte", for: .normal)
        button.layer.cornerRadius = 15
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    var outros: UIButton = {
        var button = UIButton()
        button.setTitle("Outros", for: .normal)
        button.layer.cornerRadius = 15
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SheetView: ViewCode {
    
    func setupHierarchy() {
        addSubview(verso)
        addSubview(preRefrao)
        addSubview(refrao)
        addSubview(ponte)
        addSubview(outros)
    }
    
    func setupConstraints() {
        verso.translatesAutoresizingMaskIntoConstraints = false
        preRefrao.translatesAutoresizingMaskIntoConstraints = false
        refrao.translatesAutoresizingMaskIntoConstraints = false
        ponte.translatesAutoresizingMaskIntoConstraints = false
        outros.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verso.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            verso.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            verso.widthAnchor.constraint(equalToConstant: 83),
            verso.heightAnchor.constraint(equalToConstant: 30),
            
            preRefrao.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            preRefrao.leadingAnchor.constraint(equalTo: verso.trailingAnchor, constant: 20),
            preRefrao.widthAnchor.constraint(equalToConstant: 100),
            preRefrao.heightAnchor.constraint(equalToConstant: 30),
            
            refrao.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            refrao.leadingAnchor.constraint(equalTo: preRefrao.trailingAnchor, constant: 20),
            refrao.widthAnchor.constraint(equalToConstant: 83),
            refrao.heightAnchor.constraint(equalToConstant: 30),
            
            ponte.topAnchor.constraint(equalTo: verso.bottomAnchor, constant: 30),
            ponte.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            ponte.widthAnchor.constraint(equalToConstant: 83),
            ponte.heightAnchor.constraint(equalToConstant: 30),
            
            outros.topAnchor.constraint(equalTo: preRefrao.bottomAnchor, constant: 30),
            outros.leadingAnchor.constraint(equalTo: ponte.trailingAnchor, constant: 20),
            outros.widthAnchor.constraint(equalToConstant: 83),
            outros.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .systemGray
    }
}
