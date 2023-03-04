import SwiftUI

@main
struct synthApp: App {
    
    @StateObject var chatViewModel = ChatViewModel()
    
    var body: some Scene {
        WindowGroup {
            ChatView(model: chatViewModel)
        }
    }
}
