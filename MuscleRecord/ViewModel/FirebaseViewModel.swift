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
    @Published var oldRecord: Record?
    //ログイン状態
    var isLoggedIn: Bool {
        Auth.auth().currentUser != nil
    }
    
    private var firestoreEvents: CollectionReference? {
        guard let userId = Auth.auth().currentUser?.uid else { return nil }
        return Firestore.firestore().collection("users").document(userId).collection("events")
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
        firestoreEvents?.document(event.id).updateData(["name": newName]) { error in
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
        firestoreEvents?.document(event.id).delete() { error in
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
        firestoreEvents?.addDocument(data: ["name": name, "latestWeight": 0.0, "latestRep": 0, "latestDate": Date(timeInterval: -60*60*24, since: .now)]) { error in
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
        firestoreEvents?.getDocuments { snapshot, error in
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
        firestoreEvents?.document(event.id).collection("records").order(by: "date").getDocuments { [weak self] snapshot, error in
            if let error {
                print("getRecord error: \(error.localizedDescription)")
                return
            }
            self?.createRecords(snapshot?.documents)
        }
    }
    //記録
    func addRecord(event: Event, weight: Float, rep: Int, completion: (() -> ())?) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        firestoreEvents?.document(event.id).setData(["name": event.name, "latestWeight": weight, "latestRep": rep, "latestDate": Date()]) { error in
            if let error {
                print("addRecord error1: \(error.localizedDescription)")
            }
        }
        //トップページの最新の記録も更新
        firestoreEvents?.document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep]) { error in
            completion?()

            if let error {
                print("addRecord error2: \(error.localizedDescription)")
            }
        }
    }
    //記録を上書き
    func updateRecord(event: Event, weight: Float, rep: Int, completion: (() -> ())?) {
        let db = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let group = DispatchGroup()
        
        group.enter()
        firestoreEvents?.document(event.id).collection("records").order(by: "date", descending: true).limit(to: 1).getDocuments { [weak self] snapshot, error in
            if let error {
                print("updateRecord error1: \(error.localizedDescription)")
                group.leave()
                return
            }
            guard let latestDocumentId = snapshot?.documents.first?.documentID else {
                group.leave()
                return
            }
            
            self?.firestoreEvents?.document(event.id).collection("records").document(latestDocumentId).delete { error in
                if let error {
                    print("Error deleting document: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.addRecord(event: event, weight: weight, rep: rep) {
                completion?()
            }
        }
    }
    
    private func createRecords(_ documents: [QueryDocumentSnapshot]?) {
        guard let documents else { return }
        DispatchQueue.main.async {
            self.createDailyRecords(documents)
            self.createAverageRecords(documents)
        }
    }
    
    private func createDailyRecords(_ documents: [QueryDocumentSnapshot]) {
        documents.forEach { d in
            let timeStamp: Timestamp = d["date"] as? Timestamp ?? Timestamp()
            let date = timeStamp.dateValue()
            //記録に間が空いている場合はダミーを作成
            if let oldRecord {
                var dateDifference = (Calendar.current.dateComponents([.day], from: oldRecord.date, to: timeStamp.dateValue())).day! - 1
                while dateDifference > 0 {
                    self.records.append(Record(date: .init(timeInterval: .init(-60*60*24*dateDifference), since: date), weight: oldRecord.weight, rep: oldRecord.rep, dummy: true))
                    dateDifference -= 1
                }
            }
            let record = Record(id: d.documentID, date: date, weight: d["weight"] as? Float ?? 0, rep: d["rep"] as? Int ?? 0, dummy: false)
            oldRecord = record
            records.append(record)
            
            if maxWeight < d["weight"] as? Float ?? 0.0 {
                maxWeight = d["weight"] as? Float ?? 0.0
            }
        }
    }
    
    private func createAverageRecords(_ documents: [QueryDocumentSnapshot]) {
        let periodArray = [3,9]
        
        for period in periodArray {
            var totalDate = 0
            var totalWeight: Float = 0
            var totalRep = 0
            
            let fractionCount = records.count % period
            var createdfraction = false
            records.forEach { record in
                totalWeight += record.weight
                totalRep += record.rep
                totalDate += 1
                //余った部分を最初に作成
                if fractionCount != 0 && fractionCount == totalDate && createdfraction == false {
                    let record = Record(date: record.date, weight: totalWeight/Float(fractionCount), rep: totalRep/fractionCount, dummy: false)
                    if period == 3 {
                        records3.append(record)
                    } else {
                        records9.append(record)
                    }
                    createdfraction = true
                    totalWeight = 0
                    totalRep = 0
                    totalDate = 0
                }
                //平均を作成
                if totalDate == period {
                    let record = Record(date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false)
                    if period == 3 {
                        records3.append(record)
                    } else {
                        records9.append(record)
                    }
                    totalWeight = 0
                    totalRep = 0
                    totalDate = 0
                }
            }
        }
    }
}
