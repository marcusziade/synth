import SwiftUI

struct ChatView: View {
    
    @ObservedObject var model: ChatViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                switch model.state {
                case .idle:
                    searchFieldView
                        .padding()
                    
                case .loading:
                    ProgressView()
                        .progressViewStyle(.linear)
                    searchFieldView
                    
                case .error(let message):
                    Text(message)
                    searchFieldView
                    
                case .result(let response):
                    Text(response)
                        .textSelection(.enabled)
                    Button("Copy") {}
                    searchFieldView
                }
            }
        }
        .padding()
    }
    
    private var searchFieldView: some View {
        HStack {
            TextEditor(text: $model.chatInputString)
                .cornerRadius(4)
            VStack {
                Button {
                    Task { await model.generateResponse() }
                } label: {
                    Text("Send")
                }
                Button {
                    model.state = .idle
                } label: {
                    Text("Clear")
                }
                Spacer()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(model: ChatViewModel.mock)
    }
}
