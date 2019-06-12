//
//  File.swift
//  
//
//  Created by Callum Trounce on 11/06/2019.
//

import Foundation
import Combine


extension JSONDecoder: TopLevelDecoder {  }

@available(iOS 13.0, *)
class Networker {
    
    private lazy var session = URLSession.init(configuration: .default)
    
    /// Executes an asyncronous download task.
    /// - Parameter url: url you wish to retrieve data from.
    func downloadTask(url: URL) -> Publishers.Future<(URLResponse, URL), Error> {
        return Publishers.Future.init { [weak self] result in
            let request = self?.session.downloadTask(with: url, completionHandler: { (downloadLocation, response, error) in
                if let error = error {
                    result(.failure(error))
                    return
                }
                
                if let response = response, let downloadLocation = downloadLocation {
                    result(.success((response, downloadLocation)))
                    return
                }
            })
            
            let observation = request?.observe(\.progress) { progress, _ in
                print(progress)
            }
            
            request?.resume()
        }
    }
    
    /// Perform an asyncronous data task from a remote url.
    /// - Parameter url: url at which you wish to retreive data.
    func dataTask(url: URL) -> Publishers.Future<Data, Error> {
        return Publishers.Future.init { [weak self] result in
            let request = self?.session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    result(.failure(error))
                    return
                }
                
                if let data = data {
                    result(.success(data))
                    return
                }
            })
            
            request?.resume()
        }
    }
    
    /// Requests a decodable resource from a remote path.
    /// - Parameter url: url at which the decodable data is held
    /// - Parameter JSONDecoder: decoder used for custom decoding.
    func requestDecodable<T: Decodable>(from url: URL,
                                        decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return dataTask(url: url)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
