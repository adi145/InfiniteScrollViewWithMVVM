//
//  NetworkClient.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

// MARK: -
protocol NetworkClient {
    func request<T>(type: T.Type,
                    service: EndpointProtocol,
                    completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable
}

// MARK: -
final class DefaultNetworkClient: NetworkClient {

    private var session: URLSessionProtocol

    init(session: URLSession = URLSession(configuration: DefaultURLSessionConfiguration().configuration)) {
        self.session = session
    }

    func request<T>(type: T.Type,
                    service: EndpointProtocol,
                    completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        if let reachability = Reachability(), !reachability.isReachable {
            print(reachability.currentReachabilityStatus)
            return completion(.failure(.noInternet))
        }
        let request = URLRequest(service: service)
        debugPrint("======= request ========",request)

        let task = session.dataTask(request: request, completionHandler: { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        })
        task.resume()
    }

    private func handleDataResponse<T: Decodable>(data: Data?,
                                                  response: HTTPURLResponse?,
                                                  error: Error?,
                                                  completion: (Result<T, NetworkError>) -> Void) {
        guard error == nil else {
            switch (error as NSError?)?.code {
            case NSURLErrorTimedOut:
                return completion(.failure(.timeout))
            default:
                return completion(.failure(.generalError))
            }
        }

        guard let response = response else {
            return completion(.failure(.noData))
        }
        
        switch response.statusCode {
        case 200...299:
//            let jsonResult = try! JSONSerialization.jsonObject(with: data ?? Data(), options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//          //  print("++++++++++++ Json Results ++++++++++",jsonResult ?? [String:Any]())
            guard let data = (T.self == EmptyResponse.self ? Data("{}".utf8) : data),
                  let model = try? JSONDecoder().decode(T.self, from: data) else {
                return completion(.failure(.noData))
            }
            debugPrint("======= response ========",model)
            completion(.success(model))
        default:
            let error = NetworkError.handleErrorResponse(errorCode: response.statusCode)
            completion(.failure(error))
        }
    }
}
