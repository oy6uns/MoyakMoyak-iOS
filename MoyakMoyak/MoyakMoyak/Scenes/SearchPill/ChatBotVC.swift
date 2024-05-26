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
    private var messages = [Message]()
    
    private let appName = UILabel().then{
        $0.text = "모약모약"
        $0.textColor = 0x404042.color
        $0.font = UIFont.uhbeeMiwan(type: .regular, size: 40)
    }
    
    private let tableView = UITableView().then {
        $0.register(ChatBotTVC.self, forCellReuseIdentifier: "ChatBotCell")
        $0.backgroundColor = .white
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
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private let sendButton = UIButton().then {
        $0.setImage(UIImage(named: "send_deactivate"), for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setupLayout()
    }
    
    // MARK: - Functions
    private func setupLayout() {
        view.addSubviews([appName, tableView, inputContainerView])
        
        inputContainerView.addSubviews([inputTextField, sendButton])
        
        appName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(48.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(appName.snp.bottom).offset(8.adjustedH)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputContainerView.snp.top).offset(-16)
        }
        
        inputContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-48)
            $0.height.equalTo(50)
        }
        
        inputTextField.snp.makeConstraints {
            $0.leading.equalTo(inputContainerView).offset(20)
            $0.centerY.equalTo(inputContainerView)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalTo(inputContainerView).offset(-12)
            $0.centerY.equalTo(inputContainerView)
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
    }
    
    func scrollToBottom(animated: Bool) {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    
    // MARK: - Handlers
    @objc private func handleSend() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        
        let userMessage = Message(text: text, isIncoming: false)
        messages.append(userMessage)
        
        /// 더미 답변 추가
        let botResponse = Message(text: "잠을 자야 내일 수업을 듣죠 이사람아. 또 가서 졸거야? 어? 말좀 해봐", isIncoming: true)
        messages.append(botResponse)
        
        inputTextField.text = nil
        textFieldDidChange()
        
        tableView.reloadData()
        scrollToBottom(animated: false)
    }
    
    @objc private func textFieldDidChange() {
        let hasText = !inputTextField.text!.isEmpty
        let imageName = hasText ? "send_activate" : "send_deactivate"
        sendButton.setImage(UIImage(named: imageName), for: .normal)
        sendButton.isEnabled = hasText
    }
}

// MARK: - UITableViewDelegate
extension ChatBotVC: UITableViewDelegate {}

// MARK: - UITableViewDataSource
extension ChatBotVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBotCell", for: indexPath) as? ChatBotTVC else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        print(message.text)
        cell.configure(with: message)
        return cell
    }
}

