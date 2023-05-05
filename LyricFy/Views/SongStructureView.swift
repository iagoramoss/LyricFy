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
        tableView.register(SongStructureCell.self, forCellReuseIdentifier: SongStructure.reuseIdentifier)
        
        tableView.dragInteractionEnabled = true
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    init(delegate: SongStructureTableView) {
        self.delegate = delegate
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupAdditionalConfiguration() {
        self.tableView.dataSource = delegate
        self.tableView.delegate = delegate
        self.tableView.dragDelegate = delegate
    }
}
