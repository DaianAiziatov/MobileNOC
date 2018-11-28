//
//  APIClient.swift
//  MobileNOCAssessment
//
//  Created by Daian Aiziatov on 27/11/2018.
//  Copyright © 2018 Daian Aiziatov. All rights reserved.
//

import Foundation

final class APIClient {
    private lazy var baseURL: URL = {
        return URL(string: "https://45.55.43.15:9090/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchMachines(with request: APIRequest, page: Int, completion: @escaping (Result<MachinePage, DataResponseError>) -> Void) {
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        let parameters = ["page": "\(page)"]
        var encodedURLRequest = urlRequest.encode(with: parameters)
        let loginString = String(format: "%@:%@", request.username, request.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        encodedURLRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(DataResponseError.network))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(MachinePage.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
}
