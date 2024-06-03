//
//  SearchPillVC.swift
//  MoyakMoyak
//
//  Created by saint on 2024/05/26.
//

import UIKit
import SnapKit
import Then
import Moya

class ChatBotVC: BaseVC {
    
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
    
    // MoyaProvider 설정
    let provider = MoyaProvider<UserRouter>(requestClosure: { (endpoint: Endpoint, done: @escaping MoyaProvider.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            // Here you can modify the request if needed
            print("Request URL: \(request.url?.absoluteString ?? "No URL")")
            done(.success(request))
        } catch {
            done(.failure(MoyaError.underlying(error, nil)))
        }
    })
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        setupLayout()
        hideKeyboardWhenTappedAround()
        setupKeyboardNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            $0.top.equalTo(appName.snp.bottom).offset(16.adjustedH)
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
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    @objc private func handleSend() {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        
        let userMessage = Message(text: text, isIncoming: false)
        messages.append(userMessage)
        
        inputTextField.resignFirstResponder()
        
        sendMessageToChatbot(prompt: text) { [weak self] response in
            guard let self = self else { return }
            let botResponse = Message(text: response, isIncoming: true)
            self.messages.append(botResponse)
            
            self.inputTextField.text = nil
            self.textFieldDidChange()
            
            self.tableView.reloadData()
            self.scrollToBottom(animated: false)
        }
    }
    
    private func sendMessageToChatbot(prompt: String, completion: @escaping (String) -> Void) {
        let chatRequest = ChatRequestDto(query: prompt)
        print(chatRequest)
        provider.request(.chatMessage(param: chatRequest)) { result in
            print(result)
            switch result {
            case .success(let response):
                do {
                    let chatResponse = try JSONDecoder().decode(ChatResponseDto.self, from: response.data)
                    completion(chatResponse.answer + "\n" + "출처: \n" + chatResponse.references)
                } catch {
                    completion("Error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error: \(error)")
                completion("Error: Request failed")
            }
        }
    }
    
    @objc private func textFieldDidChange() {
        let hasText = !inputTextField.text!.isEmpty
        let imageName = hasText ? "send_activate" : "send_deactivate"
        sendButton.setImage(UIImage(named: imageName), for: .normal)
        sendButton.isEnabled = hasText
    }
    
    // MARK: - UIGestureRecognizerDelegate
    /// 보내기 버튼 눌렀을 때만 BaseVC의 hideKeyboardWhenTappedAround가 동작 안하게끔 touch 영역에서 제외시킨다.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != sendButton
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset.bottom = bottomInset
            self.tableView.scrollIndicatorInsets.bottom = bottomInset
            self.inputContainerView.transform = CGAffineTransform(translationX: 0, y: -bottomInset)
            self.scrollToBottom(animated: true)
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset.bottom = 0
            self.tableView.scrollIndicatorInsets.bottom = 0
            self.inputContainerView.transform = .identity
        }
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

