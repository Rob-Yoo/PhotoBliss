//
//  Literal.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import Foundation

enum Literal {
    enum NavigationTitle {
        static let ourTopic = "OUR TOPIC"
        static let newProfile = "PROFILE SETTING"
        static let search = "SEARCH PHOTO"
        static let editProfile = "EDIT PROFILE"
        static let likeList = "MY PhotoBliss"
    }
    
    enum Placeholder {
        static let nickname = "닉네임을 입력해주세요 :)"
        static let search = "키워드 검색"
    }
    
    enum NicknameStatus {
        static let ok = "사용 가능한 닉네임입니다 :D"
        static let countError = "2글자 이상 10글자 미만으로 설정해주세요"
        static let characterError = "닉네임에 @, #, $, % 는 포함할 수 없어요."
        static let numError = "닉네임에 숫자는 포함할 수 없어요."
        static let whitespaceError = "올바르지 않은 띄어쓰기에요. (올바른 예시: 옹골찬 고래밥)"
    }
    
    enum ButtonTitle {
        static let start = "시작하기"
        static let complete = "완료"
        static let deleteAccount = "회원탈퇴"
        static let save = "저장"
    }
    
    enum TopicTrend {
        static let title = "OUR TOPIC"
    }
    
    enum PhotoSearch {
        static let emptySearchKeyword = "사진을 검색해보세요."
        static let emptySearchResult = "검색 결과가 없어요."
    }
    
    enum PhotoDetail {
        static let info = "정보"
        static let size = "크기"
        static let viewCount = "조회수"
        static let downloadCount = "다운로드"
    }
    
    enum LikeList {
        static let emptyLikeList = "저장된 사진이 없어요."
    }
    
    enum ToastMessage {
        static let addLike = "사진이 좋아요 목록에 저장됩니다."
        static let deleteLike = "사진이 좋아요 목록에서 삭제됩니다."
        static let invalidLike = "사진 정보를 받아올 수 없어\n 좋아요 처리 되지 못합니다."
    }
}
