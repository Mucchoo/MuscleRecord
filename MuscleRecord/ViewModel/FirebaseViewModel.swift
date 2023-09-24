//
//  FirebaseViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/06/12.
//

import Foundation
import Firebase

class FirebaseViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var records = [Record]()
    @Published var records3 = [Record]()
    @Published var records9 = [Record]()
    @Published var records27 = [Record]()
    @Published var maxWeight: Float = 0.0
    @Published var latestRecord: String = ""
    @Published var oldRecord: Record?
    //ログイン状態
    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser == nil {
            return false
        } else {
            return true
        }
    }
    //サインイン
    func signIn(email: String, password: String) -> String? {
        var errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("signIn error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
        return errorMessage
    }
    //アカウント作成
    func signUp(email: String, password: String, completion: @escaping (String?) -> ()) {
        var errorMessage = ""
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("signUp error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
                completion(errorMessage)
            } else {
                guard let _ = authResult?.user else { return }
                Auth.auth().signIn(withEmail: email, password: password)
                let db = Firestore.firestore()
                let userID = Auth.auth().currentUser!.uid
                db.collection(R.string.localizable.users()).document(userID).setData([R.string.localizable.email(): email])
                completion(nil)
            }
        }
    }
    //メールアドレス変更
    func changeEmail(into: String) -> String? {
        var errorMessage = ""
        Auth.auth().currentUser?.updateEmail(to: into) { error in
            if let error = error as NSError? {
                print("changeEmail error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
        return errorMessage
    }
    //パスワード変更
    func changePassword(into: String) -> String? {
        var errorMessage = ""
        Auth.auth().currentUser?.updatePassword(to: into) { error in
            if let error = error as NSError? {
                print("changePassword error: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
        return errorMessage
    }
    //パスワードリセット
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error {
                print("resetPassword error: \(error.localizedDescription)")
                return
            }
        }
    }
    //サインアウト
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("signOut error: \(error.localizedDescription)")
        }
    }
    //種目名の更新
    func updateEvent(event: Event, newName: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).updateData([R.string.localizable.name(): newName]) { error in
            if let error {
                print("updateEvent error: \(error.localizedDescription)")
                return
            }
        }
    }
    //種目の削除
    func deleteEvent(event: Event) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).delete() { error in
            if let error {
                print("deleteEvent error: \(error.localizedDescription)")
                return
            }
        }
    }
    //種目の追加
    func addEvent(_ name: String) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).addDocument(data: [R.string.localizable.name(): name, R.string.localizable.latestWeight(): 0.0, R.string.localizable.latestRep(): 0, R.string.localizable.latestDate(): Date(timeInterval: -60*60*24, since: .now)]) { error in
            if let error {
                print("addEvent error: \(error.localizedDescription)")
                return
            }
        }
    }
    //種目の取得
    func getEvent() {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).getDocuments { snapshot, error in
            if let error {
                print("getEvent error: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            DispatchQueue.main.async {
                self.events = snapshot.documents.map { d in
                    let timeStamp = d[R.string.localizable.latestDate()] as! Timestamp
                    return Event(id: d.documentID, name: d[R.string.localizable.name()] as? String ?? "", latestWeight: d[R.string.localizable.latestWeight()] as? Float ?? 0.0, latestRep: d[R.string.localizable.latestRep()] as? Int ?? 0, latestDate: timeStamp.dateValue())
                }
            }
        }
    }
    //記録の取得
    func getRecord(event: Event) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).collection(R.string.localizable.records()).order(by: R.string.localizable.date()).getDocuments { (snapshot, error) in
            if let error {
                print("getRecord error: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            DispatchQueue.main.async {
                snapshot.documents.forEach { d in
                    self.latestRecord = d.documentID
                    let timeStamp: Timestamp = d[R.string.localizable.date()] as? Timestamp ?? Timestamp()
                    let date = timeStamp.dateValue()
                    //記録に間が空いている場合はダミーを作成
                    if let oldRecord = self.oldRecord {
                        var dateDifference = (Calendar.current.dateComponents([.day], from: oldRecord.date, to: timeStamp.dateValue())).day! - 1
                        while dateDifference > 0 {
                            self.records.append(Record(id: UUID().uuidString, date: Date(timeInterval: TimeInterval(-60*60*24*dateDifference), since: date), weight: oldRecord.weight, rep: oldRecord.rep, dummy: true))
                            dateDifference -= 1
                        }
                    }
                    let record = Record(id: d.documentID, date: date, weight: d[R.string.localizable.weight()] as? Float ?? 0, rep: d[R.string.localizable.rep()] as? Int ?? 0, dummy: false)
                    self.oldRecord = record
                    self.records.append(record)
                }
                //最大重量
                snapshot.documents.forEach { d in
                    if self.maxWeight < d[R.string.localizable.weight()] as? Float ?? 0.0 {
                        self.maxWeight = d[R.string.localizable.weight()] as? Float ?? 0.0
                    }
                }
            }
        }
    }
    //記録
    func addRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).setData([R.string.localizable.name(): event.name, R.string.localizable.latestWeight(): weight, R.string.localizable.latestRep(): rep, R.string.localizable.latestDate(): Date()]) { error in
            if let error {
                print("addRecord error1: \(error.localizedDescription)")
                return
            }
        }
        //トップページの最新の記録も更新
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).collection(R.string.localizable.records()).addDocument(data: [R.string.localizable.date(): Date(), R.string.localizable.weight(): weight, R.string.localizable.rep(): rep]) { error in
            if let error {
                print("addRecord error2: \(error.localizedDescription)")
                return
            }
        }
    }
    //記録を上書き
    func updateRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        //一番新しい記録を削除
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).collection(R.string.localizable.records()).order(by: R.string.localizable.date(), descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error {
                print("updateRecord error1: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach { d in
                let latestRecordID = d.documentID
                db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).collection(R.string.localizable.records()).document(latestRecordID).delete()
            }
        }
        //トップページの最新の記録も更新
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).setData([R.string.localizable.name(): event.name, R.string.localizable.latestWeight(): weight, R.string.localizable.latestRep(): rep, R.string.localizable.latestDate(): Date()]) { error in
            if let error {
                print("updateRecord error2: \(error.localizedDescription)")
                return
            }
        }
        //記録を上書き
        db.collection(R.string.localizable.users()).document(userID).collection(R.string.localizable.events()).document(event.id).collection(R.string.localizable.records()).addDocument(data: [R.string.localizable.date(): Date(), R.string.localizable.weight(): weight, R.string.localizable.rep(): rep]) { error in
            if let error {
                print("updateRecord error3: \(error.localizedDescription)")
                return
            }
        }
    }

}
