//
//  ChatView.swift
//  LineChat
//
//  Created by 町田和輝 on 2023/12/29.
//

import SwiftUI

struct ChatView: View {
    
    let chat: Chat
    
    @State private var textFieldText: String = ""
    @State private var scrollTarget: Int?
    @FocusState private var textFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var vm: ChatViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            messageArea
                .overlay(navigationArea,alignment: .top)
            inputArea
        }
    }
}

//#Preview {
//    ChatView(chat: chat)
//}

extension ChatView {
    
    private var messageArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(chat.messages){ message in
                        MessageRow(message: message)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 72)
            }
            .background(Color("Background"))
            .onTapGesture {
                textFieldFocused = false
            }
            .onAppear {
                scrollToLast(proxy: proxy)
            }
            .onChange(of: scrollTarget) { target in
                if let target = target {
                    scrollTarget = nil
                    withAnimation {
                        scrollToLast(proxy: proxy)
                    }
                }
            }
        }
    }
    
    private var inputArea: some View {
        HStack {
            HStack {
                Image(systemName: "plus")
                Image(systemName: "camera")
                Image(systemName: "photo")
            }
            .font(.title2)
            TextField("Aa", text: $textFieldText)
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .clipShape(Capsule())
                .overlay(
                    Image(systemName: "face.smiling")
                        .font(.title2)
                        .padding(.trailing)
                        .foregroundColor(.gray)
                    
                    , alignment: .trailing
                )
                .onSubmit {
                    sendMessage()
                    // メッセージ送った時に最後のメッセージを出すようにしたい
                    scrollTarget = 0
                }
                .focused($textFieldFocused)
            Image(systemName: "mic")
                .font(.title2)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(uiColor: .systemBackground))
    }
    
    private var navigationArea: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            Text("Title")
                .font(.title2.bold())
            Spacer()
            HStack(spacing: 16) {
                Image(systemName: "text.magnifyingglass")
                Image(systemName: "phone")
                Image(systemName: "line.3.horizontal")
            }
            .font(.title2)
        }
        .padding()
        .background(Color("Background").opacity(0.9))
    }
    
    private func sendMessage() {
        if !textFieldText.isEmpty {
            vm.addMessage(chatId: chat.id,text: textFieldText)
            textFieldText = ""
        }
    }
    
    private func scrollToLast(proxy: ScrollViewProxy) {
        if let lastMessage = chat.messages.last {
            proxy.scrollTo(lastMessage.id, anchor: .zero)
        }
    }
}
