//
//  User.swift
//  LineChat
//
//  Created by 町田和輝 on 2023/12/29.
//

import Foundation

struct User: Decodable, Encodable {
    let id: String
    let name: String
    let image: String
    
    var isCurrentUser: Bool {
        self.id == User.currentUser.id
    }
    
    static var currentUser: User {
        User(id: "1", name: "カーキ", image: "user01")
    }
}
