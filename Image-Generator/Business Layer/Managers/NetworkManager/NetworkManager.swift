//
//  NetworkManager.swift
//  Image-Generator
//
//  Created by Shuhrat Nurov on 03/05/23.
//

import Foundation

enum Router {
    case getImage
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "dummyimage.com"
    }
    
    var path: String {
        switch self {
        case .getImage:
            return "/500x500&text=some+text"
        }
    }
    
    func url() -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        return components.url!
    }
}

enum Endpoint {
    case getImage(text: String)
    
    var path: String {
        switch self {
        case .getImage(let text):
            return "/500x500&text=\(text)"
        }
    }
}

enum NetworkError: Error {
    case invalidData
}


enum ResultType<T> {
    case success(model: T)
    case failure(error: Error)
}

enum HttpMethod: String {
    case get
    case post
    var method: String { rawValue.uppercased() }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL: URL = URL(string: "https://dummyimage.com")!
    
    func request<T: Decodable>(fromURL url: URL, httpMethod: HttpMethod = .get, completion: @escaping (ResultType<T>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let data = data, let response = response as? HTTPURLResponse,
               (response.statusCode >= 200 && response.statusCode < 300) {
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(model: model))
                    }
                } catch {
                    completion(.failure(error: error))
                }
            } else {
                if let error = error as? Error {
                    completion(.failure(error: error))
                }
            }
        }

        task.resume()
    }
    
    func getImage(endPoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(endPoint.path)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
            }
            task.resume()
        }
}


