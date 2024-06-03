//
//  OpenAIService.swift
//  MoyakMoyak
//
//  Created by saint on 2024/06/03.
//

import UIKit
import Moya

enum OpenAIService {
    case sendMessage(prompt: String)
}

extension OpenAIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openai.com/v1")!
    }
    
    var path: String {
        switch self {
        case .sendMessage:
            return "/chat/completions"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .sendMessage(let prompt):
            let parameters: [String: Any] = [
                "model": "gpt-4",
                "messages": [
                    ["role": "system", "content": "당신은 경험 많은 전문적인 약사입니다. 사람들이 약과 관련하여 질문한 내용에 대해 친절하게 대답해주세요. 그리고, 해당 약에 대한 정보를 얻고 싶은 사람들에게는 'connectdi.com'에서 그 약의 정보가 있는 페이지의 링크를 담아서 주면 더 좋을거 같아요. 답변은 300-350 단어 내외로 작성해 주세요, 그리고 전문가로서의 조언이 담긴 친근하고 격려적인 어조를 사용해 주세요. 그렇지만, 흔하게 알려진 주의사항을 길게 답변할 필요는 없을 거 같아요. 최대한 간략하고, 핵심정보만 내비칠 수 있게 답변해주세요. 또한, 약물간의 상호작용에 대한 질문이라면 그 상호작용 및 부작용에 집중하여 답변을 해주세요."],
                    ["role": "user", "content": prompt]
                ],
                "max_tokens": 500
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Authorization": "Bearer ",
            "Content-Type": "application/json"
        ]
    }
}
