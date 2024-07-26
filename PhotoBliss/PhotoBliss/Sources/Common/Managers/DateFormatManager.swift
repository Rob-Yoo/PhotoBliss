//
//  DateFormatManager.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/26/24.
//

import Foundation

final class DateFormatManager {
    private let inputFormatter = DateFormatter()
    private let outputFormatter = DateFormatter()
    
    static let shared = DateFormatManager()
    
    private init() {}
    
    func convertDateFormat(inputDateFormat: String, outputDateFormat: String, dateString: String) -> String? {
        inputFormatter.dateFormat = inputDateFormat
        
        if let date = inputFormatter.date(from: dateString) {
            outputFormatter.dateFormat = outputDateFormat
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}
