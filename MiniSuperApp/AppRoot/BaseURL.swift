//
//  BaseURL.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/22.
//

import Foundation

struct BaseURL {
    var financeBaseURL: URL {
        #if UITESTING
        return URL(string: "http://localhost:8000")!
        #else
        return URL(string: "https://finance.superapp.com/api/v1")!
        #endif
    }
}
