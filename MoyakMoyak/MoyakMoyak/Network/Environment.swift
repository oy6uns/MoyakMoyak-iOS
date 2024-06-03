//
//  Environment.swift
//  PicPractice
//
//  Created by saint on 2023/04/28.
//

import Foundation

// MARK: - Environment
struct Environment {
    static let baseURL: String = {
        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("BASE_URL is not set in Info.plist")
        }
        return baseURL.replacingOccurrences(of: " ", with: "")
    }()
}
