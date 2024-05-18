//
//  BaseRequest.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation

protocol BaseRequest {
    associatedtype ResponseType: Decodable
    
    var url: URL { get }
}
