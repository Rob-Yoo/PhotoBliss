//
//  ToastStyle+Extension.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/28/24.
//

import Toast

extension ToastStyle {
    static var shadowToastStyle: ToastStyle {
        var toastStyle = ToastStyle()
        
        toastStyle.backgroundColor = .darkGray
        toastStyle.displayShadow = true
        toastStyle.shadowRadius = 4
        toastStyle.horizontalPadding = 30
        return toastStyle
    }
}
