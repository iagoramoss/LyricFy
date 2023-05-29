//
//  PartView.swift
//  LyricFy
//
//  Created by Iago Ramos on 01/05/23.
//

import Foundation
import UIKit

class PartView: UIView, ViewCode {
    
    var delegate: PartDelegate

    lazy var imageView: UIImageView = {
           let image = UIImageView()
           image.image = UIImage(named: "imagePlaceholder")
           return image
        }()

    lazy var placeholder: UILabel = {
        let label = UILabel()
        label.text = "You haven't written any part of the song."
        label.textColor = .colors(name: .placeholderColor)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(PartCell.self, forCellReuseIdentifier: PartCell.reuseIdentifier)
        tableView.register(CompositionHeader.self,
                           forHeaderFooterViewReuseIdentifier: CompositionHeader.reuseIdentifier)
        tableView.dragInteractionEnabled = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(delegate: PartDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    func setupHierarchy() {
        addSubview(tableView)
        tableView.addSubview(imageView)
        tableView.addSubview(placeholder)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28),

            placeholder.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeholder.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10)
        ])
    }
    
    func setupAdditionalConfiguration() {
        tableView.dataSource = delegate
        tableView.delegate = delegate
        tableView.dragDelegate = delegate
        tableView.dropDelegate = delegate
        
        tableView.backgroundColor = .colors(name: .bgColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
