//
//  SettingPage.swift
//  Blindar
//
//  Created by Suji Lee on 7/31/24.
//

import SwiftUI

struct SettingPage: View {
    @EnvironmentObject var userVM: UserViewModel
    @State var isOnedayModeOn: Bool = false
    @State var isDailyNotificationOn: Bool = false
    @State var settingFeature: SettingFeature = .none
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 60) {
                HStack(spacing: 8) {
                    //프로필
                    Image("SplashAppIcon")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: screenWidth * 0.2)
                    Text(userVM.user.name)
                        .font(.title)
                    Spacer()
                    //로그아웃
                    Button(action: {
                        
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.hex00497B)
                            .frame(width: screenHeight * 0.11, height: screenWidth * 0.1)
                            .overlay {
                                Text("로그아웃")
                                    .foregroundStyle(Color.white)
                            }
                    })
                }
                .padding(.top, 30)
                VStack(alignment: .leading, spacing: 50) {
                    //하루씩 보기 모드
                    CustomBlock(isOnedayModeOn: $isOnedayModeOn, isDailyNotificationOn: $isDailyNotificationOn, settingFeature: .onedayMode)
                    //데일리 알림
                    CustomBlock(isOnedayModeOn: $isOnedayModeOn, isDailyNotificationOn: $isDailyNotificationOn, settingFeature: .dailyNotification)
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
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle(Text("설정"))
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
            case .dailyNotification:
                Toggle(isOn: $isDailyNotificationOn, label: {
                    VStack(alignment: .leading) {
                        Text("데일리 알림")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("""
                매일 오전 8시에 식단, 학사일정, 메모를 알림으로
                받아볼 수 있습니다.
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
    SettingPage()
}
