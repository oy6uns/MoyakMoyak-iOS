//
//  ChatModel.swift
//  MoyakMoyak
//
//  Created by saint on 2024/05/27.
//

class Message {
    let text: String
    let isIncoming: Bool
    var isAnimated: Bool /// 애니메이션이 완료되었는지 여부를 나타내는 플래그
    
    init(text: String, isIncoming: Bool, isAnimated: Bool = false) {
        self.text = text
        self.isIncoming = isIncoming
        self.isAnimated = isAnimated
    }
}
