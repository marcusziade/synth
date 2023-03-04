import Combine
import Foundation

final class ChatViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case result(response: String)
        case error(message: String)
    }

    @Published var state: State = .idle
    @Published var chatInputString = "Tell Skynet what's on your mind..."
    @Published var chatOutputString = ""

    #warning("Refactor app to ask for APIKey on first launch and store in keychain.")
    init(
        api: OpenAIAPI = OpenAIAPI(apiKey: Keys.apiKey.rawValue)
    ) {
        self.api = api
        
        $state.sink { [unowned self] state in
            if case .idle = state {
                chatInputString = "Send something..."
                chatOutputString = ""
            }
        }
        .store(in: &cancellables)
    }
    
    @MainActor func generateResponse() async {
        state = .loading
        
        let request = ChatGenerationRequest(
            model: "gpt-3.5-turbo",
            messages: [ChatMessage(role: "user", content: chatInputString)],
            temperature: nil,
            topP: nil,
            n: nil,
            stream: nil,
            stop: nil,
            maxTokens: nil,
            presencePenalty: nil,
            frequencyPenalty: nil,
            logitBias: nil,
            user: nil
        )
        
        do {
            let response = try await api.generateChatCompletions(request: request)
            guard let content = response.choices.first?.message.content else {
                state = .error(message: "No response, try again...")
                return
            }
            state = .result(response: content)
        } catch {
            debugPrint(error, error.localizedDescription)
            state = .error(message: "\(error)\n\n\(error.localizedDescription)")
        }
    }
    
    static var mock: ChatViewModel {
        let vm = ChatViewModel()
        vm.chatInputString = "Say something, Skynet"
        vm.chatOutputString = "Something..."
        return vm
    }

    // MARK: Private
    
    private var cancellables = Set<AnyCancellable>()
    private let api: OpenAIAPI
}
