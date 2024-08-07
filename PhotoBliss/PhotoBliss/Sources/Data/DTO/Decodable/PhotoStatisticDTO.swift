//
//  PhotoStatisticDTO.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation

struct PhotoStatisticDTO: Decodable {
    let downloads: DownloadStatisticDTO
    let views: ViewStatisticDTO
}

struct DownloadStatisticDTO: Decodable {
    let total: Int
    let historical: DownloadHistoryDTO
}

struct DownloadHistoryDTO: Decodable {
    let values: [DailyDownloadHistoryDTO]
}

struct DailyDownloadHistoryDTO: Decodable {
    let date: String
    let value: Int
}

struct ViewStatisticDTO: Decodable {
    let total: Int
    let historical: ViewHistoryDTO
}

struct ViewHistoryDTO: Decodable {
    let values: [DailyViewHistoryDTO]
}

struct DailyViewHistoryDTO: Decodable {
    let date: String
    let value: Int
}
