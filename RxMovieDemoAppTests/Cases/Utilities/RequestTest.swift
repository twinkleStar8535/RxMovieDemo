//
//  RequestTest.swift
//  RequestTest
//
//  Created by YcLin on 2025/4/18.
//

import Foundation
import XCTest
import RxSwift
@testable import RxMovieDemoApp

class RequestTest: XCTestCase {

    private var sut: MockRequestService?
    private var mockItems: [MockSuccessDataClass]?
    private var disposeBag = DisposeBag()
    private var serverError: ServerError?
    
    override func setUpWithError() throws {
        sut = MockRequestService()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockItems = nil
        disposeBag = DisposeBag()
    }
    
    // MARK: - Mock Data
    private func loadMockJSONFile(named fileName: String) -> URL? {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        return URL(fileURLWithPath: path)
    }
    
    // MARK: - Success Cases
    func test_getRequestSucsess_case() {
        // Given
        let expectation = XCTestExpectation(description: "Request should succeed and parse data.")
        guard let pathURL = loadMockJSONFile(named: "requestMock") else {
            XCTFail("mock.json not found in test bundle")
            return
        }
    
        // When
        sut?
            .request(url: pathURL, method: .get, data: nil, header: nil, type: [MockSuccessDataClass].self)
            .subscribe(
                onNext: { mockClasses in
                    self.mockItems = mockClasses
                    expectation.fulfill()
                },
                onError: { error in
                    print("Error occurred in request: \(error.localizedDescription)")
                    XCTFail("Request failed with error: \(error.localizedDescription)")
                    expectation.fulfill()
                },
                onCompleted: {
                    print("Request completed")
                }
            )
            .disposed(by: disposeBag)
    
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(mockItems, "Mock items should not be nil")
        XCTAssertTrue(mockItems?.count ?? 0 > 0, "Should have at least one category")
    }
    
    func test_postRequestSuccess_case() {
        // Given
        let expectation = XCTestExpectation(description: "Post should succeed and parse data.")
        guard let pathURL = loadMockJSONFile(named: "requestMock") else {
            XCTFail("mock.json not found in test bundle")
            return
        }
        
        var mockData: Data?
        do {
            mockData = try Data(contentsOf: pathURL)
        } catch {
            XCTFail("Parse To Data Failed")
            return
        }
        
        // When
        sut?
            .request(url: pathURL, method: .post, data: mockData, header: nil, type: [MockSuccessDataClass].self)
            .subscribe(
                onNext: { mockClasses in
                    self.mockItems = mockClasses
                    expectation.fulfill()
                },
                onError: { error in
                    print("Error occurred in request: \(error.localizedDescription)")
                    XCTFail("Fetch Post failed with error: \(error.localizedDescription)")
                    expectation.fulfill()
                },
                onCompleted: {
                    print("Request completed")
                }
            )
            .disposed(by: disposeBag)
    
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(mockItems, "Mock items should not be nil")
        XCTAssertTrue(mockItems?.count ?? 0 > 0, "Should have at least one category")
    }
    
    

    
    // Fail Now
    func test_getRequestFail_invalidPath_case() {
        // Given
        let expectation = XCTestExpectation(description: "Request should fail with invalid path.")
        let invalidURL = URL(string: "invalid://path")
        
        // When
        sut?
            .request(url: invalidURL, method: .get, data: nil, header: nil, type: MockFailDataClass.self)
            .subscribe(
                onNext: { _ in
                    XCTFail("Should not receive any data")
                },
                onError: { error in
                    // Then
                    XCTAssertTrue(error is ServerError, "Error should be of type ServerError")
                    if case ServerError.invalidURL = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected invalidURL error, got \(error)")
                    }
                },
                onCompleted: {
                    XCTFail("Should not complete successfully")
                }
            )
            .disposed(by: disposeBag)
    
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_getRequestFail_parsingError_case() {
        // Given
        let expectation = XCTestExpectation(description: "Request should fail with parsing error.")
        guard let pathURL = loadMockJSONFile(named: "requestMock") else {
            XCTFail("invalidMock.json not found in test bundle")
            return
        }
        
        // When
        sut?
            .request(url: pathURL, method: .get, data: nil, header: nil, type: MockFailDataClass.self)
            .subscribe(
                onNext: { _ in
                    XCTFail("Should not receive any data")
                },
                onError: { error in
                    // Then
                    XCTAssertTrue(error is ServerError, "Error should be of type ServerError")
                    if case ServerError.parsingFailure = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected parsingFailure error, got \(error)")
                    }
                },
                onCompleted: {
                    XCTFail("Should not complete successfully")
                }
            )
            .disposed(by: disposeBag)
    
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    // Fail Now
    func test_getRequestFail_httpError_case() {
        // Given
        let expectation = XCTestExpectation(description: "Request should fail with HTTP error.")
        guard let pathURL = loadMockJSONFile(named: "errorMock") else {
            XCTFail("errorMock.json not found in test bundle")
            return
        }
        
        // When
        sut?
            .request(url: pathURL, method: .get, data: nil, header: nil, type: MockFailDataClass.self)
            .subscribe(
                onNext: { _ in
                    XCTFail("Should not receive any data")
                },
                onError: { error in
                    // Then
                    XCTAssertTrue(error is ServerError, "Error should be of type ServerError")
                    if case ServerError.requestFailure = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Expected requestFailure error, got \(error)")
                    }
                },
                onCompleted: {
                    XCTFail("Should not complete successfully")
                }
            )
            .disposed(by: disposeBag)
    
        wait(for: [expectation], timeout: 5.0)
    }
}
