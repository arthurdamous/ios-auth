//
//  Note.swift
//  AuthApp
//
//  Created by Arthur Damous on 01/11/22.
//

import Foundation


struct NotesResponse : Codable{
    let listOfNotes: [Note]
}

struct Note : Codable {
    let _id: String
    let title: String
    let description: String
    let created: String
    let modified: String
}
