//
//  ContactView.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/23.
//

import SwiftUI

struct ContactView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    @FocusState private var focus: Bool
    @State private var text = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    var body: some View {
        SimpleNavigationView(title: "ご意見・ご要望") {
            ZStack{
                viewModel.clearColor
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        focus = false
                    }
                VStack(spacing: 0){
                    HStack {
                        Text("メッセージ内容")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.fontColor)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(viewModel.getThemeColor().opacity(0.1))
                            .frame(height: 200)
                        TextEditor(text: $text)
                            .font(.headline)
                            .focused($focus)
                            .padding(.horizontal, 10)
                            .frame(height: 200)
                        VStack{
                            Text("アプリの不具合や改善点、ご意見をお気軽にお書きください！")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(viewModel.fontColor.opacity(text.isEmpty ? 0.5 : 0))
                                .padding(10)
                            Spacer()
                        }.frame(height: 200)
                    }
                    Button( action: {
                        //送信メソッド
                    }){
                        ButtonView(text: "メッセージを送信").padding(.top, 20)
                    }
                    .alert(isPresented: $isShowAlert) {
                        if isError {
                            return Alert(title: Text("エラーが発生しました"), message: Text(errorMessage), dismissButton: .default(Text("OK"))
                            )
                        } else {
                            return Alert(title: Text("メールを送信しました"), message: Text("受け取ったメールを開いてパスワードを再設定してください。"), dismissButton: .default(Text("OK"), action: {
                                dismiss()
                            }))
                        }
                    }
                    Spacer()
                }
                .padding(20)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focus = true
                    }                }
            }
        }
    }
}

