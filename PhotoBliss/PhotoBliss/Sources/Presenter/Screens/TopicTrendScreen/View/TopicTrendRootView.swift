//
//  TopicTrendRootView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/24/24.
//

import UIKit
import SnapKit
import Then

protocol TopicTrendRootViewDelegate: AnyObject {
    func refresh()
    func photoCellTapped(photo: PhotoCellModel)
}

final class TopicTrendRootView: BaseView {
    
    private var topicList = [TopicModel]()
    
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
        $0.refreshControl = self.refreshControl
    }
    
    private lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    weak var delegate: TopicTrendRootViewDelegate?
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
        self.addSubview(tableView)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
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
    
    @objc private func refreshData(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.delegate?.refresh()
            refresh.endRefreshing()
        }
    }
}

extension TopicTrendRootView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topicList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let topic = self.topicList[indexPath.item]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicTrendTableViewCell.reusableIdentifier, for: indexPath) as? TopicTrendTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(topic: topic.title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let topicCell = cell as? TopicTrendTableViewCell else {
            return
        }

        topicCell.collectionView.tag = indexPath.row
        topicCell.collectionView.delegate = self
        topicCell.collectionView.dataSource = self
        
        // 리로드가 되면 맨 처음 Cell로 이동시켜야 하는데, left로 하게 되면 EdgeInset이 먹히지 않는 것처럼 동작함 -> centeredHorizontally로 하니까 성공함
        let indexPath = IndexPath(row: 0, section: 0)
        topicCell.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idx = collectionView.tag
        let photo = self.topicList[idx].trendPhotos[indexPath.item]
        
        delegate?.photoCellTapped(photo: photo)
    }
}
