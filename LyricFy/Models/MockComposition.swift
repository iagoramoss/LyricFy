////
////  MockComposition.swift
////  LyricFy
////
////  Created by Afonso Lucas on 03/05/23.
////
//
//import Foundation
//
//class MockCompositionData {
//    
//    static var shared = MockCompositionData()
//    
//    var composition: Composition = Composition(id: UUID(), name: "Somewhere only we know")
//    
//    private init() {
//        var mainVersion = Version(id: UUID(), name: "v1", compositionParts: [])
//        
//        let verse = Part(id: UUID(), type: "Verse", lyrics: """
//        I walked across an empty land
//        I knew the pathway like the back of my hand
//        I felt the earth beneath my feet
//        Sat by the river, and it made me complete
//        """)
//        
////        let preChorus = Part(id: UUID(), type: "Pre-Chorus", lyrics: """
//        Oh, simple thing, where have you gone?
//        I'm getting old and I need something to rely on
//        So tell me when you're gonna let me in
//        I'm getting tired and I need somewhere to begin
//        """)
//        
//        mainVersion.compositionParts.append(verse)
//        mainVersion.compositionParts.append(preChorus)
//    }
//}
