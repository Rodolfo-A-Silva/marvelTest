

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
}

enum HttpMethod: String {
    case get = "GET"
}

struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

class APIService {
    
    private let limit = 20
    
    let marvelAPI = MarvelAPI()
    
    func load<T>(_ name: String?, page: Int,resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(marvelAPI.privateKey)\(marvelAPI.apiKey)".md5
        
        var components = URLComponents(url: marvelAPI.baseURL.appendingPathComponent("v1/public/characters"), resolvingAgainstBaseURL: true)
        
        var customQueryItems = [URLQueryItem]()
        
        if let name = name {
            customQueryItems.append(URLQueryItem(name: "name", value: name))
        }
        
        if page > 0 {
            customQueryItems.append(URLQueryItem(name: "offset", value: "\(page * limit)"))
        }
        
        let commonQueryItems = [
            URLQueryItem(name: "ts", value: timestamp),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "apikey", value: marvelAPI.apiKey)
        ]
        
        components?.queryItems = commonQueryItems + customQueryItems
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "", code: 000, userInfo: ["message": "Can't build url"]) as! NetworkError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.domainError))
                return
            }
            let result = try? JSONDecoder().decode(T.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
