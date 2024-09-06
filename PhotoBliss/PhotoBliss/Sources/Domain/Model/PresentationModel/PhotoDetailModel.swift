//
//  PhotoDetailModel.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation
import DGCharts

struct PhotoDetailModel {
    
    var photo: PhotoCellModel
    let viewCount: Int?
    let downloadCount: Int?
    let viewHistory: [ChartDataEntry]?
    let downLoadHistory: [ChartDataEntry]?
    
    static func createPhotoDetailModel(photo: PhotoCellModel, photoStatistic: PhotoStatisticDTO) -> Self {
        
        return PhotoDetailModel(
            photo: photo,
            viewCount: photoStatistic.views.total,
            downloadCount: photoStatistic.downloads.total,
            viewHistory: createViewHistory(photoStatistic.views.historical.values),
            downLoadHistory: createDownloadHistory(photoStatistic.downloads.historical.values)
        )
    }
    
    static func createPhotoDetailModel(photo: PhotoCellModel) -> Self {
        return PhotoDetailModel(photo: photo, viewCount: nil, downloadCount: nil, viewHistory: nil, downLoadHistory: nil)
    }
    
    private static func createViewHistory(_ histories: [DailyViewHistoryDTO]) -> [ChartDataEntry] {
        var historyModels = [ChartDataEntry]()
        
        for (idx, history) in histories.enumerated() {
            let chartData = ChartDataEntry(x: Double(idx), y: Double(history.value))
            historyModels.append(chartData)
        }

        return historyModels
    }
    
    private static func createDownloadHistory(_ histories: [DailyDownloadHistoryDTO]) -> [ChartDataEntry] {
        var historyModels = [ChartDataEntry]()
        
        for (idx, history) in histories.enumerated() {
            let chartData = ChartDataEntry(x: Double(idx), y: Double(history.value))
            historyModels.append(chartData)
        }
        
        return historyModels
    }
}
