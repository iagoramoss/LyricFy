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
    
    lazy var labelTopPlaceHolder: UILabel = {
        let view = UILabel()
        view.text = "Create Music\nyour way"
        view.numberOfLines = 2
        view.textAlignment = .center
        view.font = .customFont(fontName: .ralewayMedium, style: .title2, size: 22)
        view.textColor = .colors(name: .placeholderColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelBottomPlaceHolder: UILabel = {
        let view = UILabel()
        view.text = "You don't have a song yet."
        view.font = .customFont(fontName: .ralewayMedium, style: .subheadline, size: 15)
        view.textColor = .colors(name: .placeholderColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var imagePlaceHolder: UIImageView = {
        let view = UIImageView(image: UIImage(named: "placeHolderNoSession"))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    lazy var placeHolder: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 14
        view.alignment = .center
        [labelTopPlaceHolder, imagePlaceHolder, labelBottomPlaceHolder].forEach { view.addArrangedSubview($0) }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init(delegate: PartDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupView()
    }
    
    func setupHierarchy() {
        tableView.addSubview(placeHolder)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imagePlaceHolder.widthAnchor.constraint(equalToConstant: 172),
            imagePlaceHolder.heightAnchor.constraint(equalToConstant: 172),
            
            placeHolder.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeHolder.centerYAnchor.constraint(equalTo: self.centerYAnchor)
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
