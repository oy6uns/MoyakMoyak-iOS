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
        messageLabel.text = message.text
        selectionStyle = .none
        containerView.layer.maskedCorners = message.isIncoming ? [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] : [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView.backgroundColor = message.isIncoming ? 0xDEF1FC.color : 0x212121.color
        messageLabel.textColor = message.isIncoming ? .black : .white
        messageLabel.textAlignment = message.isIncoming ? .left : .right
    }
}
