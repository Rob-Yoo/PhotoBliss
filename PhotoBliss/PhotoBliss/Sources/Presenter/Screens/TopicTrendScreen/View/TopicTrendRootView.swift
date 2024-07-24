//
//  TopicTrendRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import SnapKit
import Then

final class TopicTrendRootView: BaseView {
    
    private var topicList = [TopicModel]()
    
    private let profileImageView = ProfileImageView().then {
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .unselected
        $0.layer.borderColor = UIColor.mainTheme.cgColor
        $0.layer.borderWidth = 3
        $0.alpha = 1
    }
    
    private let titleLabel = UILabel().then {
        $0.text = Literal.TopicTrend.title
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 35, weight: .bold)
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.rowHeight = UIScreen.main.bounds.height * 0.35
        $0.register(TopicTrendTableViewCell.self, forCellReuseIdentifier: TopicTrendTableViewCell.reusableIdentifier)
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    override func configureHierarchy() {
        self.addSubview(profileImageView)
        self.addSubview(titleLabel)
        self.addSubview(tableView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.width.equalToSuperview().multipliedBy(0.1)
            $0.height.equalTo(profileImageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(50)
            $0.leading.equalToSuperview().offset(10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func updateUI(data: [TopicModel]) {
        self.topicList = data
        self.tableView.reloadData()
    }
}

extension TopicTrendRootView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topicList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = self.topicList[indexPath.item]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicTrendTableViewCell.reusableIdentifier, for: indexPath) as? TopicTrendTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(topic: topic.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let topicCell = cell as? TopicTrendTableViewCell else {
            return
        }

        topicCell.collectionView.tag = indexPath.row
        topicCell.collectionView.delegate = self
        topicCell.collectionView.dataSource = self
    }
}

extension TopicTrendRootView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let idx = collectionView.tag
        return self.topicList[idx].trendPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let idx = collectionView.tag
        let trendPhoto = self.topicList[idx].trendPhotos[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reusableIdentifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(cellType: .topicTrend, data: trendPhoto)
        return cell
    }
    
}
