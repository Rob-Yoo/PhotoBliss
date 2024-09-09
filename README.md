# PhotoBliss
Unsplash API를 활용하여 사진을 검색하고 좋아요 할 수 있는 앱

<br>

## 🗄️ 프로젝트 정보
- **기간** : `2024.07.22 ~ 2024.08.05` (약 2주)
- **개발 인원** : `iOS 1명`
- **지원 버전**: <img src="https://img.shields.io/badge/iOS-15.0+-black?logo=apple"/>
- **기술 스택 및 라이브러리** : `UIKit` `Network` `Swift Concurrency` `SnapKit` `Then` `Alamofire` `Kingfisher` `Realm` `DGCharts` `Toast`
- **프로젝트 주요 기능**

  - `토픽별 트렌드 사진 화면`

    - 당겨서 새로고침하여 랜덤 토픽 업데이트

    - Unsplash 사이트에서의 사진 좋아요 수 정보 제공


  - `랜덤 사진 화면`

    - 사진 작가 프로필 및 게시일 정보 제공
   
    - 사진 좋아요 기능

  
  - `사진 검색 화면`
   
    - 색감 필터 및 관련순 / 최신순 정렬 기능
 
    - Unsplash 사이트에서의 사진 좋아요 수 정보 제공
  
    - 사진 좋아요 기능


  - `좋아요 리스트 화면`

    - 최신순 / 과거순 정렬 기능
  
  
  - `사진 상세 정보 화면`

    - 사진 작가 프로필 및 게시일 / 사진 크기, 조회수, 다운로드 수 정보 제공
  
    - 30일 간 조회 수 및 다운로드 수에 대한 차트 제공

    - 사진 좋아요 기능

<br>

  | 토픽별 트렌드 화면 | 랜덤 사진 화면 | 검색 화면 | 좋아요 리스트 화면 | 상세 정보 화면 |
  |--|--|--|--|--|
  |![토픽별 트렌드](https://github.com/user-attachments/assets/285230c1-f41d-4681-8fc5-c2a5954ef36f)|![랜덤 사진](https://github.com/user-attachments/assets/7743d9c6-d84b-41b8-aad4-231129231d61)|![사진 검색](https://github.com/user-attachments/assets/a305f87f-51f5-4a0a-8ea2-35cd72ad3a2e)|![좋아요 리스트](https://github.com/user-attachments/assets/ccc2ae71-f330-4f3f-8777-54e5b5651de4)|![사진 상세](https://github.com/user-attachments/assets/9a0f891b-710c-4035-8f60-50f82b31a9fa)|

<br>

## 🧰 프로젝트 주요 기술 사항

### 아키텍처 - MVVM + Service, Repository 패턴
<img width="533" alt="스크린샷 2024-09-07 오후 4 17 26" src="https://github.com/user-attachments/assets/3afbd6fc-5614-4fd6-ad2e-16eb36ab5812">

- Repository 패턴을 사용함으로써 `외부와 로컬 데이터소스 접근 작업 추상화`

- Service 패턴을 사용함으로써 Repository에서 받아온 `데이터들의 조합 및 가공 작업 추상화`

- Custom Observable과 Input-Output 패턴을 사용하여 `VC와 VM간의 데이터 바인딩` 구현

<br>

### 로컬 저장소에 사진 저장

- 이미지를 `FileManager`를 활용해 `Documents` 폴더에 저장

  - Photo ID를 파일 이름으로 설정

- Photo ID를 Primary Key로 지정하여 저장

  - Photo ID를 조회하여 Documents 폴더에서 이미지를 가져옴

<br>

### 네트워크 작업 추상화

- `싱글턴` 패턴과 `라우터` 패턴을 사용하여 네트워크 작업과 API Request 추상화

- 네트워크 작업 메서드에 제네릭 적용

- Swift Concurrency와 Result 타입을 적용하여 가독성 개선

<br>

### 사진 검색 결과에서 좋아요 여부 판단

- 좋아요 Array를 `Set`으로 변환하여 시간복잡도를 `O(N)`으로 개선

<br>

### 온보딩 화면과 메인 화면 전환

- UIWindowScene을 활용하여 rootViewController을 교체하는 방식으로 구현

<br>

## 🚨 트러블 슈팅



## 📋 회고

### 1. 네트워크 모니터링 객체 관리 방법에 대한 아쉬움

- ViewController마다 NWPathMonitor 객체를 따로따로 만들어서 관리하였고, 이렇게 되면 엄청난 리소스 낭비 같다는 생각을 하게 됨

   - SceneDelegate에서 NWPathMonitor 객체를 하나만 만들어 관리하고, ViewController들에서 네트워크 상태 변화를 관찰하게 하는 것이 좋을 것 같다고 생각
