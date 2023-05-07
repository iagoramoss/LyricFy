//
//  ViewController.swift
//  LyricFy
//
//  Created by Iago Ramos on 25/04/23.
//

import UIKit

class MainViewController: UIViewController {
    
    var songStructures: [SongStructure] = SongStructure.mock
    
    override func loadView() {
        super.loadView()
        self.view = SongStructureView(delegate: self)
    }
}

extension MainViewController: SongStructureTableView {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return songStructures.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongStructure.reuseIdentifier,
                                                       for: indexPath) as? SongStructureCell
        else { return SongStructureCell() }
        
        cell.songStructure = songStructures[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = songStructures[indexPath.row]
        
        return [item]
    }
    
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        let cell = songStructures.remove(at: sourceIndexPath.row)
        songStructures.insert(cell, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView,
                   dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let param = UIDragPreviewParameters()
        param.backgroundColor = .clear
        
        return param
    }
}
