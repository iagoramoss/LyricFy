//
//  SheetViewController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 30/04/23.
//

import UIKit

class SheetViewController: UIViewController {

    var sheetView = SheetView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = sheetView
    }
}
