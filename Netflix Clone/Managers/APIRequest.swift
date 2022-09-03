//
//  APIRequest.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 03/09/2022.
//

import UIKit

enum APIRequestError: Error{
    case itemsNotFound
    case requestFaild
}
enum ImageRequestError: Error {
    case couldNotInitializeFromData
    case imageDataMissing
}

protocol APIRequest{
    associatedtype Response
    var path: String {get}
    var queryItems: [URLQueryItem]? {get}
    var request: URLRequest {get}
    var postData: Data? {get}
}

extension APIRequest{
    var host: String {"api.themoviedb.org"}
    var apiKey: URLQueryItem {URLQueryItem(name: "api_key", value: "fdd0fe678fa5c55267af6547d5d4f7fa")}
}

extension APIRequest{
    var queryItems: [URLQueryItem]? {nil}
    var postData: Data? {nil}
}

extension APIRequest{
    var request: URLRequest {
        var component = URLComponents()
        component.scheme = "https"
        component.host = host
        component.path = path
        component.queryItems = queryItems == nil ? [apiKey] : queryItems! + [apiKey]
        var request = URLRequest(url: component.url!)
        if let data = postData{
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
        }
        return request
    }
}

extension APIRequest where Response: Decodable{
    func send() async throws -> Response{
        let (date, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIRequestError.itemsNotFound
                }
        let decode = try JSONDecoder().decode(Response.self, from: date)
        return decode
    }
}

extension APIRequest where Response == UIImage {
    func send() async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(for:
           request)
        
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw ImageRequestError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageRequestError.couldNotInitializeFromData
        }
        
        return image
    }
}



