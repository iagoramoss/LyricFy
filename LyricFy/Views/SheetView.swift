//
//  SheetView.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 02/05/23.
//

import Foundation
import UIKit

class SheetView: UIView, ViewCode {
    var partType: String = "Verse"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Choose the composition session you want to work on:"
        label.textColor = UIColor(red: 0.294, green: 0.327, blue: 0.508, alpha: 1)
        label.font = .customFont(fontName: .ralewaySemibold, style: .body, size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var selectTypeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ title in
            var title = title
            title.font = .preferredFont(for: .subheadline, weight: .regular)
            return title
        })
        
        config.baseBackgroundColor = UIColor(red: 0.776, green: 0.776, blue: 0.784, alpha: 0.7)
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        config.cornerStyle = .large
        
        let sessionTypes = ["Verse", "Bridge", "Pre-Chorus", "Chorus"]
        
        let menu = UIMenu(children: sessionTypes.map { type in
            UIAction(title: type, handler: { [weak self] _ in self?.partType = type })
        })
        
        let button = UIButton(configuration: config)
        
        button.menu = menu
        button.contentHorizontalAlignment = .trailing
        
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        return button
    }()
    
    private lazy var buttonTitle: UILabel = {
        let label = UILabel()
        label.text = "Session"
        label.font = .preferredFont(for: .subheadline, weight: .regular)
        return label
    }()
    
    private lazy var createButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ title in
            var title = title
            title.font = .preferredFont(for: .headline, weight: .semibold)

            return title
        })
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10)
        
        let button = UIButton(configuration: config)
        
        button.setTitle("Create a session", for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        selectTypeButton.addSubview(buttonTitle)
        
        addSubview(label)
        addSubview(selectTypeButton)
        addSubview(createButton)
    }
    
    func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        selectTypeButton.translatesAutoresizingMaskIntoConstraints = false
        buttonTitle.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            selectTypeButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 28),
            selectTypeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            selectTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            buttonTitle.centerYAnchor.constraint(equalTo: selectTypeButton.centerYAnchor),
            buttonTitle.leadingAnchor.constraint(equalTo: selectTypeButton.leadingAnchor, constant: 16),
            
            createButton.topAnchor.constraint(equalTo: selectTypeButton.bottomAnchor, constant: 52),
            createButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        print(UIScreen.main.bounds.size.height)
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .colors(name: .sheetColor)
    }
}
