import Foundation

class SSEClient: ObservableObject {
    @Published var latestMessage: String = "No SSE message yet."
    private var task: URLSessionDataTask?

    func connect(to url: URL) {
        var request = URLRequest(url: url)
        request.addValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.cachePolicy = .reloadIgnoringLocalCacheData

        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                print("SSE Connection Error: \(error.localizedDescription)")
                self.latestMessage = "Error: \(error.localizedDescription)"
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                print("SSE Server Error: HTTP Status Code \(statusCode)")
                self.latestMessage = "Server Error: HTTP Status Code \(statusCode)"
                return
            }

            guard let data = data, let message = String(data: data, encoding: .utf8) else {
                print("SSE: No data or invalid encoding.")
                self.latestMessage = "No data or invalid encoding."
                return
            }

            // Basic parsing for SSE events (assuming 'data:' prefix)
            let lines = message.split(separator: "\n")
            for line in lines {
                if line.hasPrefix("data:") {
                    let eventData = String(line.dropFirst("data:".count)).trimmingCharacters(in: .whitespacesAndNewlines)
                    DispatchQueue.main.async {
                        self.latestMessage = eventData
                        print("Received SSE: \(eventData)")
                    }
                }
            }
        }
        task?.resume()
        print("Attempting to connect to SSE at: \(url.absoluteString)")
    }

    func disconnect() {
        task?.cancel()
        task = nil
        print("Disconnected from SSE.")
    }
}