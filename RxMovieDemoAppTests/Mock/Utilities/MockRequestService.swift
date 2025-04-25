//
//  MockRequestService.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/4/18.
//



import Alamofire
import Foundation
import RxSwift


class MockRequestService: RequestDelegate {
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
                request = AF.upload(data ?? Data(), to: url, method: .post, headers: nil)
                    .responseData(queue: DispatchQueue.global()) { [weak self] response in
                        
                        guard let self = self else {return}
                        
                        if let error = response.error {
                            observer.onError(ServerError.requestFailure(error.localizedDescription))
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
                request = AF.request(url,method: .delete ,headers: nil)
                
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
