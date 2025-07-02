
import Foundation

enum RESTClientError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL was invalid."
        case .requestFailed(let error):
            return "REST request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .serverError(let statusCode):
            return "Server returned an error status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode server response: \(error.localizedDescription)"
        }
    }
}

class RESTClient: ObservableObject {
    func sendCommand<T: Encodable, U: Decodable>(url: URL, method: String, body: T?, responseType: U.Type, completion: @escaping (Result<U, RESTClientError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                completion(.failure(.decodingError(error)))
                return
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

    // Example function for sending a simple command
    func sendSimpleCommand(command: String, value: String, completion: @escaping (Result<String, RESTClientError>) -> Void) {
        guard let url = URL(string: "http://localhost:8080/command") else {
            completion(.failure(.invalidURL))
            return
        }

        let body: [String: String] = ["command": command, "value": value]

        sendCommand(url: url, method: "POST", body: body, responseType: String.self) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
