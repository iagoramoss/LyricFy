//
//  HomeView.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import UIKit

class HomeView: UIView {
    lazy var collectionProjects: UICollectionView = {
        let collectionProjects = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: UICollectionViewLayout.init())
        collectionProjects.translatesAutoresizingMaskIntoConstraints = false
        collectionProjects.backgroundColor = .blue
        collectionProjects.register(ProjectsComponent.self, forCellWithReuseIdentifier: ProjectsComponent.identifier)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        collectionProjects.setCollectionViewLayout(layout, animated: false)
        collectionProjects.delegate = self
        collectionProjects.dataSource = self
        
        return collectionProjects
    }()
    
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        return longPressGesture
    }()
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .green
        button.setTitle("AAA", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(newScreen), for: .touchUpInside)
        button.addGestureRecognizer(longPressGesture)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func newScreen() {
        NotificationCenter.default.post(.init(name: Notification.Name(rawValue: "emptyView")))
    }
    
    @objc
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            self.becomeFirstResponder()
            
            let menuItemTitle = NSLocalizedString("Reset", comment: "Reset menu item title")
            let action = #selector(addA)
            let resetMenuItem = UIMenuItem(title: menuItemTitle, action: action)
            let menuController = UIMenuController.shared
            menuController.menuItems = [resetMenuItem]
            
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            let menuLocation = CGRect(x: location.x, y: location.y, width: 0, height: 0)
            menuController.showMenu(from: button, rect: button.bounds)
//            menuController.setMenuVisible(true, animated: true)
            //            print("foi")
        }
    }
    
    @objc
    func addA() {
        print("foii")
    }
    
    func addMenuItems() -> UIMenu {
        let menu = UIMenu(
            title: "UIMenu",
            children: [
                UIAction(title: "Edit name",
                         image: UIImage(systemName: "pencil.circle"),
                         state: .off) { _ in
                    print("edit name")
                },
                UIAction(title: "Delete Project",
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive,
                         state: .off) { _ in
                             print("delete version")
                         }
            ]
        )
        return menu
    }
}
extension HomeView: ViewCode {
    func setupHierarchy() {
//        button.menu = addMenuItems()
//        addSubview(button)
//        addGestureRecognizer(longPressGesture)
        addSubview(self.collectionProjects)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            button.widthAnchor.constraint(equalToConstant: 200),
//            button.heightAnchor.constraint(equalToConstant: 40),
            
            collectionProjects.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
            collectionProjects.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionProjects.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionProjects.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionProjects.dequeueReusableCell(withReuseIdentifier: ProjectsComponent.identifier,
                                                          for: indexPath) as? ProjectsComponent
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            let deleteAction = self.deleteAction(indexPath)
            return UIMenu(title: "",
                          children:
                            [
                                UIAction(title: "Edit name",
                                         image: UIImage(systemName: "pencil.circle"),
                                         state: .off) { _ in
                                             print("edit name")
                                         },
                                UIAction(title: "Delete Project",
                                         image: UIImage(systemName: "trash"),
                                         attributes: .destructive,
                                         state: .off) { _ in
                                             print("delete version")
                                         }
                            ])
        }
    }
}
