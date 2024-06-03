//
//  ChatBotTVC.swift
//  MoyakMoyak
//
//  Created by saint on 2024/05/27.
//

import UIKit
import SnapKit
import Then
import SafariServices

class ChatBotTVC: UITableViewCell, UITextViewDelegate {
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
    }
    
    private let messageTextView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.dataDetectorTypes = .link
        $0.textAlignment = .left
        $0.backgroundColor = .clear
        $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
        messageTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(messageTextView)
        
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        messageTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with message: Message) {
        fullText = message.text
        messageTextView.text = ""
        currentIndex = 0
        timer?.invalidate()
        
        selectionStyle = .none
        containerView.layer.maskedCorners = message.isIncoming ? [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] : [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.backgroundColor = message.isIncoming ? 0xDEF1FC.color : 0x212121.color
        messageTextView.textColor = message.isIncoming ? .black : .white
        messageTextView.textAlignment = message.isIncoming ? .left : .right
        
        characterImageView.isHidden = !message.isIncoming
        nameLabel.isHidden = !message.isIncoming
        
        if message.isIncoming && !message.isAnimated {
            setupIncomingLayout()
            message.isAnimated = true
            showTypingAnimation()
        } else if message.isIncoming && message.isAnimated {
            setupIncomingLayout()
            messageTextView.text = message.text
        } else {
            setupOutgoingLayout()
            messageTextView.text = message.text
        }
    }
    
    private func setupIncomingLayout() {
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
        
        containerView.addSubviews([characterImageView, nameLabel, emptyView])
        emptyView.addSubview(messageTextView)
        
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
        
        messageTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    private func setupOutgoingLayout() {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(messageTextView)
        
        containerView.snp.remakeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.lessThanOrEqualTo(260.adjustedW)
            $0.width.greaterThanOrEqualTo(60.adjustedW)
        }
        
        messageTextView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func showTypingAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateText), userInfo: nil, repeats: true)
    }
    
    @objc private func updateText() {
        if currentIndex < fullText.count {
            let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
            messageTextView.text?.append(fullText[index])
            currentIndex += 1
            
            setNeedsLayout()
            layoutIfNeeded()
            
            if let tableView = superview as? UITableView {
                UIView.performWithoutAnimation {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
                
                if let chatBotVC = tableView.delegate as? ChatBotVC {
                    chatBotVC.scrollToBottom(animated: false)
                }
            }
        } else {
            timer?.invalidate()
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        if let topVC = UIApplication.shared.keyWindow?.rootViewController {
            topVC.present(safariVC, animated: true, completion: nil)
        }
        return false
    }
}
