//
//  RequestDelegate.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/13.
//



import Alamofire
import Foundation
import RxSwift

enum ServerError: Error {
    case requestFailure(String)
    case parsingFailure
    case invalidURL
    case unknownError
    case emptyQuery
    
    var errorDescription: String? {
        switch self {
        case .requestFailure(let msg):
            return msg
        case .parsingFailure:
            return "解析失敗"
        case .invalidURL:
            return "錯誤URL連結"
        case .unknownError:
            return "未知錯誤發生"
        case .emptyQuery:
            return "該條件需要查詢條件,但值為空"
        }
    }
}

protocol RequestDelegate {
    func request<T: Decodable>(
        url: URL?,
        method: Alamofire.HTTPMethod,
        data: Data?,
        header: [String: String]?,
        type: T.Type
    ) -> Observable<T>
}

class RequestServices: RequestDelegate {
    
    var fetchStauts:Bool?
    var postStauts:Bool?
    
    func request<T: Decodable>(
        url: URL?,
        method: Alamofire.HTTPMethod,
        data: Data?,
        header: [String: String]? = nil,
        type: T.Type
    ) -> Observable<T> {
        
        return Observable.create { observer in
            
            guard let url = url else {
                DispatchQueue.main.async {
                    observer.onError(ServerError.invalidURL)
                }
                return Disposables.create()
            }
            
            let httpHeaders = header.map { HTTPHeaders($0) }
            var request: DataRequest?
            
            switch method {
            case .get:
                
                request = AF.request(url, method: .get, headers: httpHeaders)
                    .responseData(queue: DispatchQueue.global()) { [weak self] response in
                        
                        guard let self = self else {return}
                        
                        if let error = response.error {
                            observer.onError(ServerError.requestFailure(error.localizedDescription))
                            return
                        }
                        
                        guard let httpResponse = response.response else {
                            observer.onError(ServerError.unknownError)
                            return
                        }
                        
                        if !(200..<300).contains(httpResponse.statusCode) {
                            let message = String(data: response.data ?? Data(), encoding: .utf8) ?? "No message"
                            observer.onError(ServerError.requestFailure("Request failed with status code: \(httpResponse.statusCode), message: \(message)"))
                            return
                        }
                        
                        guard let data = response.data else {
                            observer.onError(ServerError.unknownError)
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let resultModel = try decoder.decode(type, from: data)
                            observer.onNext(resultModel)
                            observer.onCompleted()
                        } catch {
                            print("Decoding error: \(error)")
                            observer.onError(ServerError.parsingFailure)
                        }
                    }
                
            case .post:
                request = AF.upload(data ?? Data(), to: url, method: .post, headers: httpHeaders)
                    .responseData(queue: DispatchQueue.global()) { [weak self] response in
                        
                        guard let self = self else {return}
                        
                        if let error = response.error {
                            observer.onError(ServerError.requestFailure(error.localizedDescription))
                            return
                        }
                        
                        guard let httpResponse = response.response else {
                            observer.onError(ServerError.unknownError)
                            return
                        }
                        
                        if !(200..<300).contains(httpResponse.statusCode) {
                            let message = String(data: response.data ?? Data(), encoding: .utf8) ?? "No message"
                            observer.onError(ServerError.requestFailure("Request failed with status code: \(httpResponse.statusCode), message: \(message)"))
                            return
                        }
                        
                        if method == .post {
                            guard let data = response.data else {
                                observer.onError(ServerError.unknownError)
                                return
                            }
                            
                            do {
                                let decoder = JSONDecoder()
                                let resultModel = try decoder.decode(type, from: data)
                                observer.onNext(resultModel)
                                observer.onCompleted()
                            } catch {
                                print("Decoding error: \(error)")
                                observer.onError(ServerError.parsingFailure)
                            }
                        } else {
                            observer.onCompleted()
                        }
                    }
                
            case .delete:
                request = AF.request(url, method: .delete, headers: httpHeaders)
                    .responseData(queue: DispatchQueue.global()) { [weak self] response in
                        
                        guard let self = self else {return}
                        
                        if let error = response.error {
                            observer.onError(ServerError.requestFailure(error.localizedDescription))
                            return
                        }
                        
                        guard let httpResponse = response.response else {
                            observer.onError(ServerError.unknownError)
                            return
                        }
                        
                        if !(200..<300).contains(httpResponse.statusCode) {
                            let message = String(data: response.data ?? Data(), encoding: .utf8) ?? "No message"
                            observer.onError(ServerError.requestFailure("Request failed with status code: \(httpResponse.statusCode), message: \(message)"))
                            return
                        }
                        
                        guard let data = response.data else {
                            observer.onError(ServerError.unknownError)
                            return
                        }
                        
                        do {
                            let decoder = JSONDecoder()
                            let resultModel = try decoder.decode(type, from: data)
                            observer.onNext(resultModel)
                            observer.onCompleted()
                        } catch {
                            print("Decoding error: \(error)")
                            observer.onError(ServerError.parsingFailure)
                        }
                    }
                
            default:
                observer.onError(ServerError.requestFailure("Unsupported HTTP method: \(method)"))
                return Disposables.create()
            }
            
            return Disposables.create {
                request?.cancel()
            }
        }
    }
}
