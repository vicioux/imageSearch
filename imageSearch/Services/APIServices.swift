//
//  APIServices.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/26/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import Foundation

struct GalleryEndpoints {
    func galleryUrl(search: String?, page: Int) -> String {
        var url = "https://api.imgur.com/3/gallery/search/time/\(page)"
        if let search = search {
            url.append("?q=\(search)")
        }
        return url
    }
}

public protocol GalleryServices {
    func getGallerySearch(search: String, page: Int, callback: @escaping (_ response: SearchResponse?, _ error: Error?) -> Void)
}

extension GalleryServices {
    func getGallerySearch(search: String, page: Int, callback: @escaping (_ response: SearchResponse?, _ error: Error?) -> Void) {
        let endpoint = GalleryEndpoints().galleryUrl(search: search, page: page)
        let url = URL(string: endpoint)
        return APIServices().request(url: url, callback: callback)
    }
}

class APIServices {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func request<T>(url: URL?, callback: @escaping (_ data: T?, _ error: Error?) -> Void) where T: Codable {
        dataTask?.cancel()
        
        guard let url = url else { return }
        let request = createUrlRequest(withUrl: url)
        let decoder = JSONDecoder()
        
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    callback(nil, error)
                }
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let decoder = JSONDecoder()
                
                do {
                    let mappedObj = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        callback(mappedObj, nil)
                    }
                }
                catch let parseError {
                    DispatchQueue.main.async {
                        callback(nil, parseError)
                    }
                }
            }
        }
        
        dataTask?.resume()
    }
    
    private func createUrlRequest(withUrl url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Client-ID 126701cd8332f32", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
