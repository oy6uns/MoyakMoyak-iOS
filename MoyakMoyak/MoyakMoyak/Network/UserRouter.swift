//
//  UserRouter.swift
//  PicPractice
//
//  Created by saint on 2023/04/28.
//

import Foundation
import UIKit
import Moya

enum UserRouter {
    case drugIdentification(param: ImageRequestDto)
    case chatMessage(param:ChatRequestDto)
}

extension UserRouter: TargetType {
    var baseURL: URL {
        return URL(string: Environment.baseURL)!
    }
    
    var path: String {
        switch self {
        case .drugIdentification(param: _):
            return "predict"
        case .chatMessage(param: _):
            return "chatbot"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .drugIdentification(param: _):
            return .post
        case .chatMessage(param: _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .drugIdentification(param: let param):
            var multipartFormData: [MultipartFormData] = []
            
            /// image Data to MultipartFormData
            let imageData = MultipartFormData(provider: .data(param.image),
                                              name: "file",
                                              fileName: "file.jpeg",
                                              mimeType: "image/jpeg")
            multipartFormData.append(imageData)
            return .uploadMultipart(multipartFormData)
        case .chatMessage(param: let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .drugIdentification:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}


