//
//  MockRecorder.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 10/05/23.
//

import Foundation
import UIKit

enum StatesOfRecorder {
    case recording
    case pausedRecording
    case preparedToRecord
    
    case preparedToPlay
    case pausedPlaying
    case playing
}

class MockRecorder {
    static var sharedRecord = MockRecorder()
    
    var audioControlState: StatesOfRecorder?
}
