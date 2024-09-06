//
//  PhotoChartView.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 9/7/24.
//

import UIKit
import SnapKit
import Then
import DGCharts

final class PhotoChartView: BaseView {
    
    private let chartTitleLabel = UILabel().then {
        $0.text = "차트"
        $0.font = .black20
        $0.textColor = .black
    }
    
    private lazy var segmentedControlView = UISegmentedControl().then {
        $0.insertSegment(withTitle: "조회", at: 0, animated: true)
        $0.insertSegment(withTitle: "다운로드", at: 1, animated: true)
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    private lazy var lineChartView = LineChartView().then {
        $0.legend.enabled = false
        $0.rightAxis.enabled = false
        $0.xAxis.drawGridLinesEnabled = false
        $0.xAxis.drawLabelsEnabled = false
        $0.xAxis.labelPosition = .bottom
        $0.leftAxis.drawGridLinesEnabled = false
        $0.noDataText = "데이터를 받아오는데 실패하였습니다."
    }
    
    private var viewLineChartEntries = LineChartDataSet(entries: []).then {
        $0.colors = [NSUIColor.mainTheme]
        $0.drawCirclesEnabled = false
        $0.mode = .cubicBezier
        $0.drawFilledEnabled = true
        $0.drawValuesEnabled = false
        let gradientColors = [UIColor.white.cgColor, UIColor.mainTheme.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.0, 1.0]

        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
            $0.fill = LinearGradientFill(gradient: gradient, angle: 90)
        }
    }
    private var downloadLineChartEntries = LineChartDataSet(entries: []).then {
        $0.colors = [NSUIColor.mainTheme]
        $0.drawCirclesEnabled = false
        $0.mode = .cubicBezier
        $0.drawFilledEnabled = true
        $0.drawValuesEnabled = false
        let gradientColors = [UIColor.white.cgColor, UIColor.mainTheme.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.0, 1.0]

        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) {
            $0.fill = LinearGradientFill(gradient: gradient, angle: 90)
        }
    }
    
    override func configureView() {
        self.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        self.addSubview(chartTitleLabel)
        self.addSubview(segmentedControlView)
        self.addSubview(lineChartView)
    }
    
    override func configureLayout() {
        chartTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        segmentedControlView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(chartTitleLabel.snp.trailing).offset(50)
        }
        
        lineChartView.snp.makeConstraints {
            $0.top.equalTo(segmentedControlView.snp.bottom).offset(20)
            $0.leading.equalTo(segmentedControlView)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    func updateUI(photo: PhotoDetailModel) {
        guard let viewHistory = photo.viewHistory, let downLoadHistory = photo.downLoadHistory else {
            return
        }
        self.viewLineChartEntries.replaceEntries(viewHistory)
        self.downloadLineChartEntries.replaceEntries(downLoadHistory)
        lineChartView.data = (segmentedControlView.selectedSegmentIndex == 0) ? LineChartData(dataSet: viewLineChartEntries) : LineChartData(dataSet: downloadLineChartEntries)
    }
    
    @objc private func valueChanged(_ sender: UISegmentedControl) {
        if (viewLineChartEntries.entries.isEmpty && downloadLineChartEntries.entries.isEmpty) {
            return
        }
        lineChartView.data = (sender.selectedSegmentIndex == 0) ? LineChartData(dataSet: viewLineChartEntries) : LineChartData(dataSet: downloadLineChartEntries)
    }
}
