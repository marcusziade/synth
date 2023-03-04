import Foundation

struct ChatGenerationRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double?
    let topP: Double?
    let n: Int?
    let stream: Bool?
    let stop: String?
    let maxTokens: Int?
    let presencePenalty: Double?
    let frequencyPenalty: Double?
    let logitBias: [String: Int]?
    let user: String?
}

struct ChatMessage: Codable {
    let role: String
    let content: String
}
