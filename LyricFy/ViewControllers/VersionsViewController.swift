//
//  VersionsViewController.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 04/05/23.
//

import Foundation
import UIKit

class VersionsViewController: UIViewController {

    var versionsView = VersionsView()
    var versionsArray: [String]
    
    var doneAction: (() -> Void)?

    init(versions: [String]) {
        self.versionsArray = versions
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc
    func action(sender: UIButton) {
        if sender.titleLabel?.text == "Done" {
            self.doneAction?()
        }
        
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = versionsView

        versionsView.pickerView.delegate = self as UIPickerViewDelegate
        versionsView.pickerView.dataSource = self as UIPickerViewDataSource
        
        self.versionsView.doneButton.addTarget(self, action: #selector(action), for: .touchUpInside)
        self.versionsView.cancelButton.addTarget(self, action: #selector(action), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VersionsViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        versionsArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = versionsArray[row]
        return row
    }
    
    func selectRow(row: Int) {
        self.versionsView.pickerView.selectRow(row, inComponent: 0, animated: true)
    }
}
