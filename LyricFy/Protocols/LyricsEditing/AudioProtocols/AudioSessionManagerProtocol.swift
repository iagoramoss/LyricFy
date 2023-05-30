//
//  AudioSessionManagerProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 30/05/23.
//

import Foundation

protocol AudioSessionManagerProtocol {
    
    var isRecordPermissionGranted: Bool { get }
    
    func requestRecordPermission()
    func prepareToRecord()
    func prepareToPlay()
}
