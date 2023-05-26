//
//  HomeView.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeView: UIView, ViewCode {
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 38, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    lazy var collectionProjects: UICollectionView = {
        let collectionProjects = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionProjects.translatesAutoresizingMaskIntoConstraints = false
        collectionProjects.backgroundColor = .none
        collectionProjects.register(ProjectsCell.self,
                                    forCellWithReuseIdentifier: ProjectsCell.identifier)
        collectionProjects.register(AddProjectsCell.self,
                                    forCellWithReuseIdentifier: AddProjectsCell.identifier)
        return collectionProjects
    }()
    
    lazy var numberOfProjects: Int = 0 {
        didSet {
            subtitle.text = "\(numberOfProjects) compositions"
        }
    }
    
    lazy var subtitle: UILabel = {
        let view = UILabel()
        view.text = "0 compositions"
        view.font = .systemFont(ofSize: 15, weight: .semibold)
        view.textColor = .colors(name: .buttonsColor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelTopPlaceHolder: UILabel = {
        let view = UILabel()
        view.text = "Create Music\nyour way"
        view.numberOfLines = 2
        view.textAlignment = .center
        view.font = .fontCustom(fontName: .ralewayMedium, size: 22)
        view.textColor = .magenta
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var labelBottomPlaceHolder: UILabel = {
        let view = UILabel()
        view.text = "You don't have a song yet."
        view.font = .fontCustom(fontName: .ralewayMedium, size: 15)
        view.textColor = .magenta
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var imagePlaceHolder: UIImageView = {
        let view = UIImageView(image: UIImage(named: "placeHolderNoProject"))
//        view.frame = .init(origin: .zero, size: .init(width: 172, height: 172))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    lazy var stackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.spacing = 8
//        stack.alignment = .center
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        [nameProject, date].forEach { stack.addArrangedSubview($0) }
//        return stack
//    }()

    lazy var placeHolder: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 14
        view.alignment = .center
        [labelTopPlaceHolder, imagePlaceHolder, labelBottomPlaceHolder].forEach { view.addArrangedSubview($0) }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    func setupHierarchy() {
        collectionProjects.addSubview(placeHolder)
        collectionProjects.addSubview(subtitle)
        addSubview(collectionProjects)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: collectionProjects.topAnchor),
            subtitle.leadingAnchor.constraint(equalTo: collectionProjects.leadingAnchor, constant: 16),
            
            imagePlaceHolder.widthAnchor.constraint(equalToConstant: 172),
            imagePlaceHolder.heightAnchor.constraint(equalToConstant: 172),
            
            placeHolder.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeHolder.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            collectionProjects.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionProjects.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionProjects.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionProjects.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
