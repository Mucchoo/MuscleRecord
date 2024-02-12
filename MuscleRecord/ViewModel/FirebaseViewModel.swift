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
    @Published var maxWeight: Float = 0.0
    @Published var latestRecord: String = ""
    @Published var latestRecord3: String = ""
    @Published var latestRecord9: String = ""
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
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
                //3日平均、9日平均、平均の作成
                let periodArray = [3,9]
                for period in periodArray {
                    var totalDate = 0
                    var totalWeight: Float = 0
                    var totalRep = 0
                    let fraction = self.records.count % period
                    var created = false
                    self.records.forEach { record in
                        totalWeight += record.weight
                        totalRep += record.rep
                        totalDate += 1
                        //余った部分を最初に作成
                        if fraction != 0 && fraction == totalDate && created == false {
                            let recordID = UUID().uuidString
                            if period == 3 {
                                self.records3.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                self.latestRecord3 = recordID
                            } else {
                                self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                self.latestRecord9 = recordID
                            }
                            created = true
                            totalWeight = 0
                            totalRep = 0
                            totalDate = 0
                        }
                        //平均を作成
                        if totalDate == period {
                            let recordID = UUID().uuidString
                            if period == 3 {
                                self.records3.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                self.latestRecord3 = recordID
                            } else {
                                self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                self.latestRecord9 = recordID
                            }
                            totalWeight = 0
                            totalRep = 0
                            totalDate = 0
                        }
                    }
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
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("events").document(event.id).setData(["name": event.name, "latestWeight": weight, "latestRep": rep, "latestDate": Date()]) { error in
            if let error {
                print("addRecord error1: \(error.localizedDescription)")
                return
            }
        }
        //トップページの最新の記録も更新
        db.collection("users").document(userID).collection("events").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep]) { error in
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
        db.collection("users").document(userID).collection("events").document(event.id).collection("records").order(by: "date", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let error {
                print("updateRecord error1: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else { return }
            snapshot.documents.forEach { d in
                let latestRecordID = d.documentID
                db.collection("users").document(userID).collection("events").document(event.id).collection("records").document(latestRecordID).delete()
            }
        }
        //トップページの最新の記録も更新
        db.collection("users").document(userID).collection("events").document(event.id).setData(["name": event.name, "latestWeight": weight, "latestRep": rep, "latestDate": Date()]) { error in
            if let error {
                print("updateRecord error2: \(error.localizedDescription)")
                return
            }
        }
        //記録を上書き
        db.collection("users").document(userID).collection("events").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep]) { error in
            if let error {
                print("updateRecord error3: \(error.localizedDescription)")
                return
            }
        }
    }

}
