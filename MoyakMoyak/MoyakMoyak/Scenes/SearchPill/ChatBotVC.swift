//
//  SearchPillVC.swift
//  MoyakMoyak
//
//  Created by saint on 2024/05/26.
//

import UIKit
import SnapKit
import Then

class ChatBotVC: UIViewController {
    
    // MARK: - Properties
    private let appName = UILabel().then{
        $0.text = "모약모약"
        $0.textColor = 0x404042.color
        $0.font = UIFont.uhbeeMiwan(type: .regular, size: 40)
    }
    
    private let tableView = UITableView().then {
        $0.register(ChatBotCell.self, forCellReuseIdentifier: "ChatBotCell")
        $0.backgroundColor = .systemMint
        $0.separatorStyle = .none
    }
    
    private let inputContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private let inputTextField = UITextField().then {
        $0.placeholder = "궁금한 것을 물어보세요"
        $0.borderStyle = .none
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let sendButton = UIButton(type: .system).then {
        $0.setTitle("➤", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubviews([appName, tableView, inputContainerView])
        
        inputContainerView.addSubviews([inputTextField, sendButton])
        
        appName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(48.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(appName.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputContainerView.snp.top).offset(-16)
        }
        
        inputContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-48)
            $0.height.equalTo(50)
        }
        
        inputTextField.snp.makeConstraints {
            $0.leading.equalTo(inputContainerView).offset(16)
            $0.centerY.equalTo(inputContainerView)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalTo(inputContainerView).offset(-12)
            $0.centerY.equalTo(inputContainerView)
            $0.width.equalTo(50)
        }
    }
    
    // MARK: - Handlers
    @objc private func handleSend() {
        // Send button action handler
        print("Send button tapped")
    }
}

class ChatBotCell: UITableViewCell {
    
    private let messageLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
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
        contentView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with message: String) {
        messageLabel.text = message
    }
}

