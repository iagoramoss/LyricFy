//
//  PartDelegate.swift
//  LyricFy
//
//  Created by Iago Ramos on 05/05/23.
//

import Foundation
import UIKit

protocol PartDelegate: UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    func reloadData()
}
