//
//  SongStructureView.swift
//  LyricFy
//
//  Created by Iago Ramos on 01/05/23.
//

import Foundation
import UIKit

class SongStructureView: UIView, ViewCode {
    
    var delegate: SongStructureTableView
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(SongStructureCell.self, forCellReuseIdentifier: Composition.reuseIdentifier)
        tableView.dragInteractionEnabled = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(delegate: SongStructureTableView) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    func setupHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupAdditionalConfiguration() {
        tableView.dataSource = delegate
        tableView.delegate = delegate
        tableView.dragDelegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
