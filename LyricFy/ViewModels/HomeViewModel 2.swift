//
//  HomeViewModel.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import Foundation

struct Project {
    let projectName: String
    let date: String
}

class HomeViewModel: ObservableObject {
    var projects: [Project] = [
        Project(projectName: "Oi", date: "21/12/12"),
        Project(projectName: "hi", date: "21/12/12"),
        Project(projectName: "buenas", date: "21/12/12"),
        Project(projectName: "dia", date: "21/12/12"),
        Project(projectName: "ok", date: "21/12/12")
    ]
}
