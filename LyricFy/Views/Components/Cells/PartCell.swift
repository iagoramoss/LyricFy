//
//  PartCell.swift
//  LyricFy
//
//  Created by Iago Ramos on 04/05/23.
//

import Foundation
import UIKit

class PartCell: UITableViewCell, ViewCode {
    
    static let reuseIdentifier = String(describing: PartCell.self)
    
    var part: Part? {
        didSet {
            title.text = part?.type.capitalized
            lyric.text = part?.lyrics
        }
    }
    
    private lazy var container: UIView = {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        container.clipsToBounds = true
        container.backgroundColor = UIColor(red: 0.959, green: 0.871, blue: 1, alpha: 1)
        return container
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(for: .title2, weight: .bold)
        title.textColor = .black
        return title
    }()
    
    private lazy var lyric: UILabel = {
        let lyric = UILabel()
        lyric.font = UIFont.preferredFont(for: .subheadline, weight: .regular)
        lyric.textColor = .black
        lyric.numberOfLines = 0
        return lyric
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupHierarchy() {
        addSubview(container)
        
        container.addSubview(title)
        container.addSubview(lyric)
    }
    
    func setupConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        lyric.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            title.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            
            lyric.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            lyric.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            lyric.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            lyric.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
    }
    
    func setupAdditionalConfiguration() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        
        let selectedView = UIView()
        selectedView.backgroundColor = .clear
        
        selectedBackgroundView = selectedView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
