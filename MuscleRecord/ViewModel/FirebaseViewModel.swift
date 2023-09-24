//
//  FirebaseViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/06/12.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var records = [Record]()
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
    func signIn(email: String, password: String, completion: @escaping (String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("signIn error: \(error.localizedDescription)")
                completion(error.localizedDescription)
            } else {
                completion(nil)
            }
        }
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
                db.collection("users").document(userID).setData(["email": email])
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
        guard let userID = getUserId() else { return }
        db.collection("users").document(userID).collection("events").document(event.id).updateData(["name": newName]) { error in
            if let error {
                print("updateEvent error: \(error.localizedDescription)")
                return
            }
        }
    }
    //種目の削除
    func deleteEvent(event: Event) {
        let db = Firestore.firestore()
        guard let userID = getUserId() else { return }
        db.collection("users").document(userID).collection("events").document(event.id).delete() { error in
            if let error {
                print("deleteEvent error: \(error.localizedDescription)")
                return
            }
        }
    }
    //種目の追加
    func addEvent(_ name: String) {
        let db = Firestore.firestore()
        guard let userID = getUserId() else { return }
        db.collection("users").document(userID).collection("events").addDocument(data: ["name": name, "latestWeight": 0.0, "latestRep": 0, "latestDate": Date(timeInterval: -60*60*24, since: .now)]) { error in
            if let error {
                print("addEvent error: \(error.localizedDescription)")
                return
            }
        }
    }
    //種目の取得
    func getEvent() {
        let db = Firestore.firestore()
        guard let userID = getUserId() else { return }
        db.collection("users").document(userID).collection("events").getDocuments { snapshot, error in
            if let error {
                print("getEvent error: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            DispatchQueue.main.async {
                self.events = snapshot.documents.map { d in
                    let timeStamp = d["latestDate"] as! Timestamp
                    return Event(id: d.documentID, name: d["name"] as? String ?? "", latestWeight: d["latestWeight"] as? Float ?? 0.0, latestRep: d["latestRep"] as? Int ?? 0, latestDate: timeStamp.dateValue())
                }
            }
        }
    }
    //記録の取得
    func getRecord(event: Event) {
        let db = Firestore.firestore()
        guard let userID = getUserId() else { return }
        db.collection("users").document(userID).collection("events").document(event.id).collection("records").order(by: "date").getDocuments { (snapshot, error) in
            if let error {
                print("getRecord error: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            DispatchQueue.main.async {
                snapshot.documents.forEach { d in
                    self.latestRecord = d.documentID
                    let timeStamp: Timestamp = d["date"] as? Timestamp ?? Timestamp()
                    let date = timeStamp.dateValue()
                    //記録に間が空いている場合はダミーを作成
                    if let oldRecord = self.oldRecord {
                        var dateDifference = (Calendar.current.dateComponents([.day], from: oldRecord.date, to: timeStamp.dateValue())).day! - 1
                        while dateDifference > 0 {
                            self.records.append(Record(id: UUID().uuidString, date: Date(timeInterval: TimeInterval(-60*60*24*dateDifference), since: date), weight: oldRecord.weight, rep: oldRecord.rep, dummy: true))
                            dateDifference -= 1
                        }
                    }
                    let record = Record(id: d.documentID, date: date, weight: d["weight"] as? Float ?? 0, rep: d["rep"] as? Int ?? 0, dummy: false)
                    self.oldRecord = record
                    self.records.append(record)
                }
                //最大重量
                snapshot.documents.forEach { d in
                    if self.maxWeight < d["weight"] as? Float ?? 0.0 {
                        self.maxWeight = d["weight"] as? Float ?? 0.0
                    }
                }
            }
        }
    }
    //記録
    func addRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        guard let userID = getUserId() else { return }
        let eventData = db.collection("users").document(userID).collection("events").document(event.id)
        //記録を追加
        eventData.collection("records").addDocument(data: [
            "date": Date(),
            "weight": weight,
            "rep": rep
        ]) { error in
            if let error {
                print("addRecord error2: \(error.localizedDescription)")
            }
        }
        //トップページの最新の記録も更新
        eventData.setData([
            "name": event.name,
            "latestWeight": weight,
            "latestRep": rep,
            "latestDate": Date()
        ]) { error in
            if let error {
                print("addRecord error1: \(error.localizedDescription)")
            }
        }
    }
    //記録を上書き
    func updateRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        guard let userID = getUserId() else { return }
        let eventData = db.collection("users").document(userID).collection("events").document(event.id)
        //一番新しい記録を削除
        eventData.collection("records").order(by: "date", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error {
                print("updateRecord error1: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No record snapshot to update")
                return
            }
            
            snapshot.documents.forEach { d in
                let latestRecord = eventData.collection("records").document(d.documentID)
                latestRecord.updateData([
                    "rep": rep,
                    "weight": weight
                ])
                print("Deleted record: \(d.documentID) event: \(event.name)")
            }
        }
        //トップページの最新の記録も更新
        eventData.setData([
            "name": event.name,
            "latestWeight": weight,
            "latestRep": rep,
            "latestDate": Date()
        ]) { error in
            if let error {
                print("updateRecord error2: \(error.localizedDescription)")
            }
        }
    }
    //アカウント削除
    func deleteAccount(password: String, completion: @escaping (Error?) -> ()) {
        guard let currentUser = Auth.auth().currentUser,
              let userEmail = currentUser.email else {
            print("Failed fetching current user or user email")
            return
        }
        //アカウント削除直前に一度ログイン
        let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
        currentUser.reauthenticate(with: credential) { [weak self] _, error in
            if let error {
                print("Reauthentication failed: \(error.localizedDescription)")
                completion(error)
                return
            }
            //アカウントデータ削除
            let db = Firestore.firestore()
            let accountData = db.collection("users").document(currentUser.uid)
            accountData.delete { error in
                if let error {
                    print("Delete account data failed: \(error.localizedDescription)")
                } else {
                    print("Deleted account data: \(currentUser.uid)")
                }
            }
            //アカウント削除
            currentUser.delete { error in
                if let error {
                    print("Delete auth failed: \(error.localizedDescription)")
                } else {
                    print("Deleted auth: \(currentUser.uid)")
                }
            }
            
            self?.signOut()
        }
    }
    
    private func getUserId() -> String? {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            print("UserId: \(userID)")
            return userID
        } else {
            print("Failed fetching user id")
            return nil
        }
    }
}
