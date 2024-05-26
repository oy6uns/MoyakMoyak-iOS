//
//  PillListVC.swift
//  Pill-osophy
//
//  Created by saint on 2023/05/30.
//

import UIKit

import SnapKit
import Then

class PillListVC: BaseVC {
    
    private let appName = UILabel().then{
        $0.text = "모약모약"
        $0.textColor = 0x404042.color
        $0.font = UIFont.uhbeeMiwan(type: .regular, size: 40)
    }
    
    private lazy var baseTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let searchBar = UISearchBar().then {
        $0.placeholder = "궁금한 알약을 검색해보세요!"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
    var filterdata: [PillModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        filterdata = pillList
        baseTableView.delegate = self
        baseTableView.dataSource = self
        searchBar.delegate = self
        registerTV()
        setLayout()
        customizeSearchBar()
        hideKeyboardWhenTappedAround()
    }
    
    private func registerTV() {
        baseTableView.register(PillListTVC.self,
                               forCellReuseIdentifier: PillListTVC.className
        )
    }
}

extension PillListVC{
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubviews([appName, searchBar, baseTableView])
        
        appName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(48.adjustedH)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        searchBar.snp.makeConstraints{
            $0.top.equalTo(appName.snp.bottom).offset(10.adjustedH)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(64)
        }
        
        baseTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10.adjustedH)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(70 * pillList.count)
        }
    }
}

extension PillListVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pillCell = tableView.dequeueReusableCell(
            withIdentifier: PillListTVC.className, for: indexPath)
                as? PillListTVC else { return UITableViewCell() }
        
        pillCell.dataBind(model: filterdata[indexPath.row])
        return pillCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension PillListVC: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdata = []
        if searchText == ""
        {
            filterdata = pillList
        }
        
        for pill in pillList{
                if pill.pillName.uppercased().contains(searchText.uppercased())
                {
                    filterdata.append(pill)
                }
        }
       
        self.baseTableView.reloadData()
    }
    
    private func customizeSearchBar() {
        // SearchBar의 구분선 숨기기
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.borderStyle = .none
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            textField.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            
            // 기존의 구분선 제거 후
            searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
            
            // Adding custom top and bottom border
            let topBorder = UIView()
            topBorder.backgroundColor = 0x8DBDD8.color
            topBorder.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(topBorder)
            
            let bottomBorder = UIView()
            bottomBorder.backgroundColor = 0x8DBDD8.color
            bottomBorder.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bottomBorder)
            
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: searchBar.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: 1),
                
                bottomBorder.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
    }
}
