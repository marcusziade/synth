import Foundation

struct ChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [ChatCompletionChoice]
    let usage: ChatCompletionUsage
}

struct ChatCompletionChoice: Codable {
    let index: Int
    let message: ChatCompletionMessage
    let finishReason: String?
}

struct ChatCompletionMessage: Codable {
    let role: String
    let content: String
}

struct ChatCompletionUsage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
}
