import Foundation

enum NetworkError: Error {
    case badUrl
    case responseError(error: String)
    case dataResponseError
    
    // Status Code Error
    case redirection
    case clientError
    case serverError
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}



class Networking {
    
    static let shared = Networking()
    
    // единая функция для удобного совершения запроосов
    func makeReq(url: URL?, method: HTTPMethod = .get, httpHeaders: [String: String] = [:], params: [String: Any], compleation: @escaping (Result<Data, NetworkError>) -> ()) {
        
        guard var url = url else {
            compleation(.failure(.badUrl))
            return
        }
        
        if method == .get, let queryUrl = urlQueryEncode(url: url, params: params) {
            url = queryUrl
        }
        
        var req = URLRequest(url: url)
        httpHeaders.forEach({
            req.addValue($0.key, forHTTPHeaderField: $0.value)
        })

        if method == .post, let body = urlBodyWithJsonEncoder(params: params) {
            req.httpBody = body
        }
        
        URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            if let error = error {
                compleation(.failure(.responseError(error: error.localizedDescription)))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                compleation(.failure(.dataResponseError))
                return
            }
            
            if let statusCodeError = self?.checkStatusCode(code: response.statusCode) {
                compleation(.failure(statusCodeError))
                return
            } else {
                compleation(.success(data))
            }
        }.resume()
    }
    
    // кодируем query для url params
    private func urlQueryEncode(url: URL, params: [String: Any]) -> URL? {
        if var components = URLComponents(string: url.absoluteString) {
            params.forEach({
                let query = URLQueryItem(name: $0.key, value: $0.value as? String)
                components.queryItems?.append(query)
            })
            if let url = components.url {
                let urlStr = url.absoluteString
                if let url = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    return URL(string: url)
                }
            }
        }
        return nil
    }
    
    // кодируем в json наши параметры для body в post запросе
    private func urlBodyWithJsonEncoder(params: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: [])
            return jsonData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // проверяем статус код ответа
    private func checkStatusCode(code: Int) -> NetworkError? {
        switch code {
        case 200..<300: return nil
        case 300..<400: return .redirection
        case 400..<500: return .clientError
        case 500..<600: return .serverError
        default: return nil
        }
    }
}
