//
//  ChatBotTVC.swift
//  MoyakMoyak
//
//  Created by saint on 2024/05/27.
//

import UIKit
import SnapKit

class ChatBotTVC: UITableViewCell {
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let messageLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    private var fullText: String = ""
    private var timer: Timer?
    private var currentIndex: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(messageLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with message: Message) {
        fullText = message.text
        messageLabel.text = ""
        currentIndex = 0
        timer?.invalidate()
        
        selectionStyle = .none
        containerView.layer.maskedCorners = message.isIncoming ? [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] : [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.backgroundColor = message.isIncoming ? 0xDEF1FC.color : 0x212121.color
        messageLabel.textColor = message.isIncoming ? .black : .white
        messageLabel.textAlignment = message.isIncoming ? .left : .right
        
        if message.isIncoming && !message.isAnimated {
            message.isAnimated = true
            showTypingAnimation()
        } else {
            messageLabel.text = message.text
        }
    }
    
    func showTypingAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateText), userInfo: nil, repeats: true)
    }
    
    @objc private func updateText() {
        if currentIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
            messageLabel.text?.append(fullText[index])
            currentIndex += 1
            
            /// 레이아웃 업데이트
            setNeedsLayout()
            layoutIfNeeded()
            
            /// 테이블 뷰의 셀 높이 갱신
            if let tableView = superview as? UITableView {
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
                
                /// 테이블 뷰를 가장 하단으로 스크롤
                if let chatBotVC = tableView.delegate as? ChatBotVC {
                    chatBotVC.scrollToBottom(animated: false)
                }
            }
        } else {
            timer?.invalidate()
        }
    }
}

