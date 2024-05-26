//
//  PicVC.swift
//  Pill-osophy
//
//  Created by saint on 2023/05/30.
//

import UIKit
import SnapKit
import Then
import Moya

class PicVC: UIViewController {
    
    // MARK: - Properties
    var pillList: [PillModel] = [
        PillModel(pillImage: "1", pillName: "아로나민골드", shortInfo: "혼합비타민제", num: 0),
        PillModel(pillImage: "2", pillName: "게보린", shortInfo: "해열.진통.소염제", num: 0),
        PillModel(pillImage: "3", pillName: "우루사", shortInfo: "간장질환용제", num: 0),
        PillModel(pillImage: "4", pillName: "타이레놀", shortInfo: "해열.진통.소염제", num: 0),
        PillModel(pillImage: "5", pillName: "머시론", shortInfo: "피임제", num: 0),
        PillModel(pillImage: "6", pillName: "인후신", shortInfo: "해열.진통.소염제", num: 0),
        PillModel(pillImage: "7", pillName: "아세트아미노펜", shortInfo: "해열.진통.소염제", num: 0),
        PillModel(pillImage: "8", pillName: "이가탄", shortInfo: "치과구강용약", num: 0),
        PillModel(pillImage: "9", pillName: "지르텍", shortInfo: "항히스타민제", num: 0),
        PillModel(pillImage: "10", pillName: "인사돌플러스", shortInfo: "치과구강용약", num: 0),
        PillModel(pillImage: "11", pillName: "임팩타민", shortInfo: "비타민 B제", num: 0),
        PillModel(pillImage: "12", pillName: "멜리안", shortInfo: "피임제", num: 0),
        PillModel(pillImage: "13", pillName: "액티리버모닝", shortInfo: "간장질환용제", num: 0),
        PillModel(pillImage: "14", pillName: "둘코락스에스", shortInfo: "하제, 완장제", num: 0),
        PillModel(pillImage: "15", pillName: "판시딜", shortInfo: "단백아미노산제제", num: 0),
        PillModel(pillImage: "16", pillName: "센시아", shortInfo: "기타의 조직세포의 기능용의약품", num: 0),
        PillModel(pillImage: "17", pillName: "모드콜에스", shortInfo: "해열.진통.소염제", num: 0),
        PillModel(pillImage: "18", pillName: "이지엔6이브", shortInfo: "해열.진통.소염제", num: 0),
        PillModel(pillImage: "19", pillName: "벤포벨", shortInfo: "기타의 비타민제", num: 0),
        PillModel(pillImage: "20", pillName: "동성정로환", shortInfo: "정장제", num: 0),
        PillModel(pillImage: "21", pillName: "카베진코와", shortInfo: "건위소화제", num: 0)
    ]
    
    var filterdata: [PillModel] = []
    
    private let closeButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "close_btn"), for: .normal)
        $0.contentMode = .scaleToFill
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "알약 사진촬영"
        $0.textColor = 0x404042.color
        $0.font = UIFont.uhbeeMiwan(type: .regular, size: 36)
    }
    
    let picView = UIImageView().then {
        $0.image = UIImage(named: "upload_pic")
        $0.backgroundColor = .clear
    }
    
    let imagePickerController = UIImagePickerController()
    
    var drugData: ImageResponseDto?
    
    let userRouter = MoyaProvider<UserRouter>(
        plugins: [NetworkLoggerPlugin(verbose: true)]
    )
    
    lazy var myPillListCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let buttonsView = ButtonsView()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        imagePickerController.delegate = self
        
        /// private Func
        setLayout()
        setPress()
        registerCVC()
        
        // 초기 버튼 타입 설정
        buttonsView.configureButtonsView(for: .twoButtons)
    }
    
    // MARK: - Function
    private func registerCVC() {
        myPillListCV.register(
            PicCVC.self, forCellWithReuseIdentifier: PicCVC.className)
    }
    
    private func setPress() {
        closeButton.press {
            if self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
            }
            self.navigationController?.dismiss(animated: true)
        }
        
        buttonsView.getPicButton().press { [self] in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
            
            // 서버 통신 후로 수정해주어야 함.
            buttonsView.getUploadButton().isUserInteractionEnabled = true
            buttonsView.getUploadButton().backgroundColor = .black
            buttonsView.getUploadButton().setTitleColor(.white, for: .normal)
        }
        
        buttonsView.getCameraButton().press { [self] in
            let pickerController = UIImagePickerController() // must be used from main thread only
            pickerController.sourceType = .camera
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            pickerController.delegate = self
            self.present(pickerController, animated: true)
            // 서버 통신 후로 수정해주어야 함.
            buttonsView.getUploadButton().isUserInteractionEnabled = true
            buttonsView.getUploadButton().backgroundColor = .black
            buttonsView.getUploadButton().setTitleColor(.white, for: .normal)
        }
        
        buttonsView.getUploadButton().press {
            let currentTime = Date()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let formattedDate = formatter.string(from: currentTime)
            
            var infoData: String = ""
            
            for pill in self.filterdata {
                if infoData.isEmpty {
                    infoData = "\(pill.pillName) \(pill.num)알"
                } else {
                    infoData += ", \(pill.pillName) \(pill.num)알"
                }
            }
            
            MyPillVC.mypillList.insert(MyPillModel(date: formattedDate, detail: infoData, image: self.picView.image!), at: 0)
            
            NotificationCenter.default.post(name: NSNotification.Name("DismissModalView"), object: nil, userInfo: nil)
            
            print(formattedDate)
            if self.navigationController == nil {
                self.dismiss(animated: true, completion: nil)
            }
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    private func settingAlert() {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            let alert = UIAlertController(title: "설정", message: "\(appName)이(가) 카메라 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default)
            let confirmAction = UIAlertAction(title: "확인", style: .default) {
                (action) in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Server
    func sendImage(param: ImageRequestDto) {
        userRouter.request(.drugIdentification(param: param)) { response in
            
            // MARK: 서버통신1 이미지 전송 후 Detection 및 부작용 탐지 결과 확인
        
            switch response {
            case .success(let result):
                let status = result.statusCode
                if status >= 200 && status < 300 {
                    do {
                        self.drugData = try result.map(ImageResponseDto.self)
                        if let result = self.drugData {
                            self.filterdata = []
                            for pill in result.drug {
                                self.pillList[pill[0] - 1].num = pill[1]
                                self.filterdata.append(self.pillList[pill[0] - 1])
                            }
                            print(self.filterdata)
                            self.myPillListCV.reloadData()
                        }
                    } catch(let error) {
                        print(error.localizedDescription)
                    }
                }
                if status >= 400 {
                    print("error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension PicVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picView.image = image
        }
        guard let image = picView.image else { return }
        let data = image.jpegData(compressionQuality: 1.0)
        if let data = data {
            let param = ImageRequestDto(image: data)
            sendImage(param: param)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Layout
extension PicVC {
    private func setLayout() {
        view.addSubViews([closeButton, titleLabel, picView, myPillListCV, buttonsView])
        
        closeButton.snp.makeConstraints {
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(16.adjustedW)
            $0.top.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20.adjustedW)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56.adjustedH)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        picView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300.adjustedW)
            $0.height.equalTo(300.adjustedW)
        }
        
        myPillListCV.snp.makeConstraints {
            $0.top.equalTo(picView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(buttonsView.snp.top).offset(-24)
        }
        
        buttonsView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(90.adjustedH)
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PicVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 360, height: 71)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

// MARK: - UICollectionViewDataSource
extension PicVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let pillCell = collectionView.dequeueReusableCell(withReuseIdentifier: PicCVC.className, for: indexPath) as? PicCVC else { return UICollectionViewCell() }
        pillCell.dataBind(model: filterdata[indexPath.row])
        return pillCell
    }
}
