//
//  NetworkManagerTests.swift
//  EnesKendirciCaseStudyTests
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import XCTest
@testable import EnesKendirciCaseStudy

final class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        networkManager = NetworkManager.shared
        
        // Register URLProtocol class
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
        
        // Unregister URLProtocol class
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testFetchSuccess() {
        // Define expectation
        let expectation = self.expectation(description: "Fetch should succeed")
        
        // Define mock data and request
        let mockData = """
        {
            "id": "1",
            "name": "Test Product",
            "image": "https://example.com/image.jpg",
            "price": "10.0",
            "description": "Test Description",
            "model": "Test Model",
            "brand": "Test Brand",
            "createdAt": "2023-05-20T12:34:56Z"
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockData)
        }
        
        struct MockRequest: BaseRequest {
            typealias ResponseType = Product
            var url: URL { return URL(string: "https://example.com")! }
        }
        
        let request = MockRequest()
        networkManager.fetch(request) { result in
            switch result {
            case .success(let product):
                XCTAssertEqual(product.name, "Test Product")
                expectation.fulfill()
            case .failure:
                XCTFail("Fetch should succeed")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImageSuccess() {
        // Define expectation
        let expectation = self.expectation(description: "Image loading should succeed")
        
        // Define mock image data
        let mockImage = UIImage(systemName: "photo")!
        let mockImageData = mockImage.pngData()!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, mockImageData)
        }
        
        let url = URL(string: "https://example.com/image.jpg")!
        networkManager.loadImage(from: url) { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadImageFailure() {
        // Define expectation
        let expectation = self.expectation(description: "Image loading should fail")
        
        // Define mock error
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: "Test", code: 0, userInfo: nil)
        }
        
        let url = URL(string: "https://example.com/image.jpg")!
        networkManager.loadImage(from: url) { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

// MockURLProtocol to intercept URL requests
class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Request handler is not set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No-op
    }
}
