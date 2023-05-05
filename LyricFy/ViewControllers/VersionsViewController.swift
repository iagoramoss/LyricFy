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

    init(versions: [String]) {
        self.versionsArray = versions
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = versionsView

        versionsView.pickerView.delegate = self as UIPickerViewDelegate
        versionsView.pickerView.dataSource = self as UIPickerViewDataSource

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onTappedDone))
        doneButton.tintColor = .blue

        navigationItem.rightBarButtonItem = doneButton
    }

    @objc
    func onTappedDone() {
        print("DONE")
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
}
