//
//  LoginView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/21.
//

import Firebase
import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Focus?
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    @State var showSignIn = false
    private var window: UIWindow? {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window else {
            return nil
        }
        return window
    }
    
    enum Focus {
        case email, password, confirm
    }
    
    var body: some View {
        ZStack{
            //背景タップでキーボードを閉じる
            viewModel.clearColor
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    focus = nil
                }
            VStack(spacing: 0){
                //タイトル
                Text("アカウント作成")
                    .font(.headline)
                    .padding(.bottom, 20)
                    .foregroundColor(viewModel.fontColor)
                //フォーム
                TextFieldView(title: "メールアドレス", text: $email, placeHolder: "example@example.com", isSecure: false)
                    .focused($focus, equals: .email)
                TextFieldView(title: "パスワード", text: $password, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .password)
                TextFieldView(title: "確認用パスワード", text: $confirm, placeHolder: "password", isSecure: true)
                    .focused($focus, equals: .confirm)
                //アカウント作成ボタン
                Button( action: {
                    errorMessage = ""
                    if email.isEmpty {
                        errorMessage = "メールアドレスが入力されていません"
                        isError = true
                        isShowAlert = true
                    } else if password.isEmpty {
                        errorMessage = "パスワードが入力されていません"
                        isError = true
                        isShowAlert = true
                    } else if confirm.isEmpty {
                        errorMessage = "確認用パスワードが入力されていません"
                        isError = true
                        isShowAlert = true
                    } else if password.compare(confirm) != .orderedSame {
                        errorMessage = "パスワードと確認パスワードが一致しません"
                        isError = true
                        isShowAlert = true
                    } else {
                        signUp()
                    }
                }){
                    ButtonView(text: "アカウント作成").padding(.top, 20)
                }
                //ログインボタン
                Button {
                    showSignIn = true
                } label: {
                    Text("既存のアカウントにログイン")
                        .font(.headline)
                        .foregroundColor(viewModel.getThemeColor())
                        .padding(.top, 30)
                }
                .alert(isPresented: $isShowAlert) {
                    //エラーアラート
                    if isError {
                        return Alert(title: Text(""), message: Text(errorMessage), dismissButton: .destructive(Text("OK"))
                        )
                    //成功アラート
                    } else {
                        return Alert(title: Text("アカウントが作成されました"), message: Text(""), dismissButton: .default(Text("OK"), action: {
                            window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }))
                    }
                }
                Spacer()
            }.padding(20)
        //ログインページ
        }.sheet(isPresented: $showSignIn) {
            SignInView()
        }
    }
    //アカウント作成
    private func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    errorMessage = "メールアドレスの形式が正しくありません"
                case .emailAlreadyInUse:
                    errorMessage = "このメールアドレスは既に登録されています"
                case .weakPassword:
                    errorMessage = "パスワードは６文字以上で入力してください"
                default:
                    errorMessage = error.domain
                }
                
                isError = true
                isShowAlert = true
            }
            
            if let _ = authResult?.user {
                isError = false
                isShowAlert = true
                Auth.auth().signIn(withEmail: email, password: password)
                let db = Firestore.firestore()
                let userID = Auth.auth().currentUser!.uid
                db.collection("users").document(userID).setData(["email": email])
            }
        }
    }
}
