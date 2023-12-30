//
//  Message.swift
//  LineChat
//
//  Created by 町田和輝 on 2023/12/29.
//

import Foundation

struct Message: Decodable, Identifiable {
    let id: String
    let text: String
    let user: User
    let date: String
    let readed: Bool
}
