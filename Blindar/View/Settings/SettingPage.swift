//
//  SettingPage.swift
//  Blindar
//
//  Created by Suji Lee on 7/31/24.
//

import SwiftUI
import SwiftData

struct SettingPage: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var uiManager: UIManager
    @EnvironmentObject var userVM: UserViewModel
    @State var isOnedayModeOn: Bool = false
    @State var isDailyNotificationOn: Bool = false
    @State var settingFeature: SettingFeature = .none
    @Binding var mainPageMode: MainPageMode
    @State private var isLogoutAlertOn = false
    @State private var isDeleteAlertOn = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("설정")
                    .font(.title)
                    .padding()
                VStack(alignment: .leading, spacing: 30) {
                    //하루씩 보기 모드
                    CustomBlock(isOnedayModeOn: $isOnedayModeOn, isDailyNotificationOn: $isDailyNotificationOn, settingFeature: .onedayMode, mainPageMode: $mainPageMode)
                    //피드백 보내기
                    NavigationLink(destination: {
                        FeedbackNavigationPage()
                    }, label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("피드백 남기기")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("블린더 앱의 사용 후기를 남겨주세요!")
                                    .font(.callout)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                    })
                }
                .padding(.bottom, 30)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.bottom)
        }
        .onAppear {
            isOnedayModeOn = mainPageMode == .oneday
        }
    }
}

enum SettingFeature {
    case onedayMode
    case dailyNotification
    case none
}

struct CustomBlock: View {
    @Binding var isOnedayModeOn: Bool
    @Binding var isDailyNotificationOn: Bool
    var settingFeature: SettingFeature
    @Binding var mainPageMode: MainPageMode
    
    var body: some View {
        VStack {
            switch settingFeature {
            case .onedayMode:
                Toggle(isOn: $isOnedayModeOn, label: {
                    VStack(alignment: .leading) {
                        Text("하루씩 보기 모드")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("""
                날짜를 직접 입력하여 정보를 볼 수 있습니다.
                스크린 리더에 최적화된 메인 화면입니다.
                """)
                        .font(.callout)
                    }
                })
                .onChange(of: isOnedayModeOn) { newValue in
                    if newValue == true {
                        mainPageMode = .oneday
                    } else {
                        mainPageMode = .calendar
                    }
                }
            case .dailyNotification:
                Toggle(isOn: $isDailyNotificationOn, label: {
                    VStack(alignment: .leading) {
                        Text("데일리 알림")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("""
                매일 오전 8시에 식단, 학사일정, 메모를
                알림으로 받아볼 수 있습니다.
                """)
                        .font(.callout)
                    }
                })
            case .none:
                EmptyView()
            }
        }
    }
}

#Preview {
    SettingPage(mainPageMode: .constant(.calendar))
        .environmentObject(UserViewModel())
}
