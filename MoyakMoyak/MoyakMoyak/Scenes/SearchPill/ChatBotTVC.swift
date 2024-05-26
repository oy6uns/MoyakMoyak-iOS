//
//  ChatBotTVC.swift
//  MoyakMoyak
//
//  Created by saint on 2024/05/27.
//

import UIKit
import SnapKit
import Then

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
    
    private let characterImageView = UIImageView().then {
        $0.image = UIImage(named: "moyak_character")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "모약"
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.isHidden = true
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
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
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
        
        characterImageView.isHidden = !message.isIncoming
        nameLabel.isHidden = !message.isIncoming
        
        if message.isIncoming && !message.isAnimated {
            setupIncomingLayout()
            message.isAnimated = true
            showTypingAnimation()
        } else if message.isIncoming && message.isAnimated {
            setupIncomingLayout()
            messageLabel.text = message.text
        } else {
            setupOutgoingLayout()
            messageLabel.text = message.text
        }
    }
    
    private func setupIncomingLayout() {
        /// 기존의 질문 뷰를 삭제 후
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.backgroundColor = .white
        
        let emptyView = UIView().then {
            $0.backgroundColor = 0xDEF1FC.color
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        containerView.snp.remakeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        /// 캐릭터와 별명이 담긴 뷰를 띄어준다.
        containerView.addSubviews([characterImageView, nameLabel, emptyView])
        emptyView.addSubview(messageLabel)
        
        characterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-4)
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(40.adjustedW)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(characterImageView.snp.trailing)
            $0.bottom.equalTo(characterImageView.snp.bottom)
        }
        
        emptyView.snp.makeConstraints {
            $0.leading.equalTo(characterImageView.snp.trailing)
            $0.top.equalTo(characterImageView.snp.bottom).offset(8)
            $0.bottom.trailing.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setupOutgoingLayout() {
        /// 기존의 답변 뷰를 삭제 후
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        /// 메시지만 담긴 뷰를 띄어준다.
        containerView.addSubview(messageLabel)
        
        containerView.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.lessThanOrEqualTo(260.adjustedW) /// 너비를 최대 260으로 설정
            $0.width.greaterThanOrEqualTo(60.adjustedW) /// 최소 너비를 설정하여 너무 좁아지지 않도록
        }
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
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

