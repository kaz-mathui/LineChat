//
//  ChatViewModel.swift
//  LineChat
//
//  Created by 町田和輝 on 2023/12/29.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    @Published var chatData: [Chat] = []
    
    init() {
        chatData = fetchChatData()
    }
    
    private func fetchChatData() -> [Chat] {
        let fileName = "chatData.json"
        let data: Data
        
        guard let filePath = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            fatalError("\(fileName)が見つかりませんでした")
        }
        
        do {
            data = try Data(contentsOf: filePath)
        } catch {
            fatalError("\(fileName)のロードに失敗しました")
        }
        
        do {
            return try JSONDecoder().decode([Chat].self, from: data)
        } catch {
            fatalError("\(fileName)を\(Chat.self)に変換することに失敗しました")
        }
    }
    
    private func saveChatData(chatData: [Chat]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let filePathStr = URL(fileURLWithPath:  "//Users/kaz/Documents/study/udemy/swiftui/LineChat/LineChat/DataServices/chatData.json")

        do {
            let data = try encoder.encode(chatData)
            if let json = String(data: data, encoding: .utf8) {
                try json.write(to: filePathStr, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Error saving chat data: \(error)")
        }
    }
    
    func addMessage(chatId: String, text: String) {
        
        guard let index = chatData.firstIndex(where: {chat in
            chat.id == chatId
        }) else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDateString = formatter.string(from: Date())
        
        let newMessage = Message(
            id: UUID().uuidString,
            text: text,
            user: User.currentUser,
            date: formattedDateString,
            readed: false
        )
        chatData[index].messages.append(newMessage)
        
        saveChatData(chatData: chatData)
    }
    
    func getTitle(messages: [Message]) -> String {
        var title = ""
        let names = getMembers(messages: messages, type: .name)
        
        for name in names {
            title += title.isEmpty ? "\(name)" : ", \(name)"
        }
        return title
    }
    
    func getImages(messages: [Message]) -> [String] { getMembers(messages: messages, type: .image) }
    
    private func getMembers(messages: [Message], type: ValueType) -> [String] {
        var members: [String] = []
        var userIds: [String] = []
        
        for message in messages {
            let id = message.user.id
            
            if id == User.currentUser.id { continue }
            if userIds.contains(id) { continue }
            
            userIds.append(id)
            
            switch type {
            case .name:
                members.append(message.user.name)
            case.image:
                members.append(message.user.image)
            }
            
        }
        
        return members
    }
}

enum ValueType {
    case name
    case image
}
