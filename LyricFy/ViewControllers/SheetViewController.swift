//
//  SheetViewController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 30/04/23.
//

import UIKit

class SheetViewController: UIViewController {

    var sheetView = SheetView()
    var action: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = sheetView
        
        sheetView.subviews.forEach { subview in
            guard let button = subview as? UIButton else {
                return
            }
            
            button.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                self.action?(self.sheetView.partType)
            }), for: .touchUpInside)
        }
    }
}
