//
//  SettingPage.swift
//  Blindar
//
//  Created by Suji Lee on 7/31/24.
//

import SwiftUI
import FirebaseAuth
import SwiftData

struct SettingPage: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var uiManager: UIManager
    @EnvironmentObject var userVM: UserViewModel
    @State var isOnedayModeOn: Bool = false
    @State var isDailyNotificationOn: Bool = false
    @State var settingFeature: SettingFeature = .none
    @Binding var mainPageMode: MainPageMode
    @State var showLogoutAlert: Bool = false
    @State var showUserDeleteAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("설정")
                    .font(.title)
                    .padding()
                HStack {
                    //프로필
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: uiManager.screenWidth * 0.17)
                        .clipShape(Circle())
                        .padding()
                        .accessibilityHidden(true)
                    Text(userVM.user?.name ?? "이름 정보 없음")
                        .font(.title2)
                    Spacer()
                }
                VStack(alignment: .leading, spacing: 30) {
                    //하루씩 보기 모드
                    CustomBlock(isOnedayModeOn: $isOnedayModeOn, isDailyNotificationOn: $isDailyNotificationOn, settingFeature: .onedayMode, mainPageMode: $mainPageMode)
                    //데일리 알림
                    //                    CustomBlock(isOnedayModeOn: $isOnedayModeOn, isDailyNotificationOn: $isDailyNotificationOn, settingFeature: .dailyNotification, mainPageMode: $mainPageMode)
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
                HStack(spacing: 70) {
                    //로그아웃
                    Button(action: {
                        showLogoutAlert = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.hex00497B)
                            .frame(width: uiManager.screenHeight * 0.11, height: uiManager.screenWidth * 0.1)
                            .overlay {
                                Text("로그아웃")
                                    .foregroundStyle(Color.white)
                            }
                    })
                    //회원 탈퇴
                    Button(action: {
                        showUserDeleteAlert = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.hex00497B)
                            .frame(width: uiManager.screenHeight * 0.11, height: uiManager.screenWidth * 0.1)
                            .overlay {
                                Text("회원 탈퇴")
                                    .foregroundStyle(Color.white)
                            }
                    })
                }
                Spacer()
            }
            .padding(.horizontal, 12)
        }
        .alert(isPresented: $showLogoutAlert) {
            Alert(title: Text("로그아웃"), primaryButton: .destructive(Text("확인"), action: {
                logout()
            }), secondaryButton: .cancel(Text("취소")))
        }
        .alert(isPresented: $showUserDeleteAlert) {
            Alert(title: Text("회원 탈퇴"), message: Text("회원의 모든 정보가 삭제됩니다"), primaryButton: .destructive(Text("확인"), action: {
                deleteUser()
            }), secondaryButton: .cancel(Text("취소")))
        }
        .onAppear {
            isOnedayModeOn = mainPageMode == .oneday
        }
    }
    
    private func logout() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    private func deleteUser() {
        //firebase 계정 삭제
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            print("An error happened")
          } else {
            print("Account deleted")
          }
        }
        //로컬 데이터 삭제
        do {
            try modelContext.delete(model: MealLocalData.self)
            try modelContext.delete(model: MemoLocalData.self)
            try modelContext.delete(model: ScheduleLocalData.self)
            try modelContext.delete(model: SchoolLocalData.self)
            try modelContext.delete(model: UserLocalData.self)
        } catch {
            print("Failed to clear all Model Context data.")
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
