//
//  CompositionScreenController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 27/04/23.
//

import UIKit

class CompositionScreenController: UIViewController {
    var compositionView = CompositionView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view = compositionView
    }
}
