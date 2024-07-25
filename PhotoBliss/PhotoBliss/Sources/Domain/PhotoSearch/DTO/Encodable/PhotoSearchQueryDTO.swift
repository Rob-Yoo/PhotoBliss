//
//  PhotoSearchQueryDTO.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/25/24.
//

import Foundation

struct PhotoSearchQueryDTO: Encodable {
    let query: String
    let page: Int
    let per_page: Int
    let order_by: String
    let color: String?
    let client_id: String
}
