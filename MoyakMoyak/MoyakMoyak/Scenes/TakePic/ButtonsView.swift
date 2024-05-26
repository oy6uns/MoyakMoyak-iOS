import UIKit
import SnapKit
import Then

class ButtonsView: UIView {
    
    private let buttonsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    private let uploadBtn = UIButton().then {
        $0.backgroundColor = 0x50A7D0.color
        $0.layer.cornerRadius = 32
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = 0x50A7D0.color.cgColor
        $0.titleLabel?.font = UIFont.uhbeezziba(size: 20)
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.isUserInteractionEnabled = false
    }
    
    private let picBtn = UIButton().then {
        $0.backgroundColor = 0x50A7D0.color
        $0.layer.cornerRadius = 32
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = 0x50A7D0.color.cgColor
        $0.titleLabel?.font = UIFont.uhbeezziba(size: 20)
        $0.setTitle("앨범에서 찾기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let cameraBtn = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 32
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = 0x50A7D0.color.cgColor
        $0.titleLabel?.font = UIFont.uhbeezziba(size: 20)
        $0.setTitle("사진 촬영하기", for: .normal)
        $0.setTitleColor(0x50A7D0.color, for: .normal)
    }
    
    enum ButtonType {
        case twoButtons
        case singleButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(buttonsStackView)
        
        buttonsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    func configureButtonsView(for type: ButtonType) {
        buttonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch type {
        case .twoButtons:
            buttonsStackView.addArrangedSubview(picBtn)
            buttonsStackView.addArrangedSubview(cameraBtn)
        case .singleButton:
            buttonsStackView.addArrangedSubview(uploadBtn)
        }
    }
    
    // MARK: - Public Methods to Access Buttons
    func getPicButton() -> UIButton {
        return picBtn
    }
    
    func getCameraButton() -> UIButton {
        return cameraBtn
    }
    
    func getUploadButton() -> UIButton {
        return uploadBtn
    }
}
