//
//  RandomPhotoQueryDTO.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 9/5/24.
//

import Foundation

struct RandomPhotoQueryDTO: Encodable {
    let count = 10
    let client_id = APIKey.key
}
