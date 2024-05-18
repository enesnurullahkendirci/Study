//
//  ProductRequest.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation

struct ProductRequest: BaseRequest {
    typealias ResponseType = [Product]
    
    var url: URL {
        return URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products")!
    }
}
