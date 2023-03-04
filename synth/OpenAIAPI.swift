import Foundation

enum APIError: Error {
    case invalidEndpoint
    case invalidResponse
    case decodingError
    case networkError(Error)
}

class OpenAIAPI {
    private let apiKey: String

    init(
        apiKey: String
    ) {
        self.apiKey = apiKey
    }
    
    func generateChatCompletions(request: ChatGenerationRequest) async throws -> ChatCompletionResponse {
        let (data, response) = try await URLSession.shared.data(for: buildRequest(for: request))

        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }

        do {
            let completionResponse = try jsonDecoder.decode(ChatCompletionResponse.self, from: data)
            return completionResponse
        } catch {
            throw APIError.decodingError
        }
    }
    
    private func buildRequest(for request: ChatGenerationRequest) throws -> URLRequest {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw APIError.invalidEndpoint
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try jsonEncoder.encode(request)
        return urlRequest
    }
    
    private let jsonEncoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }()
    
    private let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
}
