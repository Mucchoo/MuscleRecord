//
//  ViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import SwiftUI
import Firebase
import RevenueCat

class ViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var records = [Record]()
    @Published var records3 = [Record]()
    @Published var records9 = [Record]()
    @Published var records27 = [Record]()
    @Published var maxWeight: Float = 0.0
    @Published var latestID: String = ""
    @Published var latestID3: String = ""
    @Published var latestID9: String = ""
    @Published var latestID27: String = ""
    @Published var oldRecord: Record?
    @Published var fontColor = Color("FontColor")
    @Published var cellColor = Color("CellColor")
    @Published var clearColor = Color("ClearColor")
    @Published var backgroundColor = Color("BackgroundColor")
    //内課金購入状態
    func customerInfo() -> Bool {
        var isPro = false
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            
            guard error == nil else {
                print("内課金購入時のエラー\(error!)")
                return
            }
            
            if customerInfo?.entitlements["Pro"]?.isActive == true {
                isPro = true
            }
        }
        return isPro
    }
    //テーマカラーの取得
    func getThemeColor() -> Color {
        switch UserDefaults.standard.integer(forKey: "themeColorNumber") {
        case 0:
            return Color("ThemeColor0")
        case 1:
            return Color("ThemeColor1")
        case 2:
            return Color("ThemeColor2")
        case 3:
            return Color("ThemeColor3")
        case 4:
            return Color("ThemeColor4")
        case 5:
            return Color("ThemeColor5")
        default:
            return Color("ThemeColor0")
        }
    }
    //記録時のdateFormat
    func dateFormat(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: date)
    }
    //種目名の更新
    func updateEvent(event: Event, newName: String) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("users").document(userID).collection("events").document(event.id).updateData(["name": newName]) { error in
                guard error == nil else {
                    print("種目更新時のエラー\(error!)")
                    return
                }
            }
        }
    }
    //種目の削除
    func deleteEvent(event: Event) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("users").document(userID).collection("events").document(event.id).delete() { error in
                guard error == nil else {
                    print("種目削除時のエラー\(error!)")
                    return
                }
            }
        }
    }
    //種目の追加
    func addEvent(_ name: String) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("users").document(userID).collection("events").addDocument(data: ["name": name, "latestWeight": 0.0, "latestRep": 0, "latestDate": Date(timeInterval: -60*60*24, since: .now)]) { error in
                guard error == nil else {
                    print("種目追加時のエラー\(error!)")
                    return
                }
            }
        }
    }
    //種目の取得
    func getEvent() {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("users").document(userID).collection("events").getDocuments { snapshot, error in
                
                guard error == nil else {
                    print("種目取得時のエラー\(error!)")
                    return
                }
                
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.events = snapshot.documents.map { d in
                            let timeStamp = d["latestDate"] as! Timestamp
                            return Event(id: d.documentID, name: d["name"] as? String ?? "", latestWeight: d["latestWeight"] as? Float ?? 0.0, latestRep: d["latestRep"] as? Int ?? 0, latestDate: timeStamp.dateValue())
                        }
                    }
                }
            }
        }
    }
    //記録の取得
    func getRecord(event: Event) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("users").document(userID).collection("events").document(event.id).collection("records").order(by: "date").getDocuments { (snapshot, error) in
                if let snapshot = snapshot{
                    
                    guard error == nil else {
                        print("記録取得時のエラー\(error!)")
                        return
                    }
                    
                    DispatchQueue.main.async {
                            snapshot.documents.forEach { d in
                                self.latestID = d.documentID
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
                            //3日平均、9日平均、27日平均の作成
                            let periodArray = [3,9,27]
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
                                            self.latestID3 = recordID
                                        } else if period == 9 {
                                            self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                            self.latestID9 = recordID
                                        } else if period == 27 {
                                            self.records27.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                            self.latestID27 = recordID
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
                                            self.latestID3 = recordID
                                        } else if period == 9 {
                                            self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                            self.latestID9 = recordID
                                        } else if period == 27 {
                                            self.records27.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(period), rep: totalRep/period, dummy: false))
                                            self.latestID27 = recordID
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

        }
    }
    //記録
    func addRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            db.collection("users").document(userID).collection("events").document(event.id).setData(["name": event.name, "latestWeight": weight, "latestRep": rep, "latestDate": Date()]) { error in
                guard error == nil else {
                    print("記録追加時（種目更新）のエラー\(error!)")
                    return
                }
            }
            //トップページの最新の記録も更新
            db.collection("users").document(userID).collection("events").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep]) { error in
                guard error == nil else {
                    print("記録追加時のエラー\(error!)")
                    return
                }
            }
        }
    }
    //記録を上書き
    func updateRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        if let userID = Auth.auth().currentUser?.uid {
            //一番新しい記録を削除
            db.collection("users").document(userID).collection("events").document(event.id).collection("records").order(by: "date", descending: true).limit(to: 1).getDocuments { snapshot, error in
                
                guard error == nil else {
                    print("記録更新時（古い記録削除）のエラー\(error!)")
                    return
                }
                
                if let snapshot = snapshot {
                    snapshot.documents.forEach { d in
                        let latestRecordID = d.documentID
                        db.collection("users").document(userID).collection("events").document(event.id).collection("records").document(latestRecordID).delete()
                    }
                }
            }
            //トップページの最新の記録も更新
            db.collection("users").document(userID).collection("events").document(event.id).setData(["name": event.name, "latestWeight": weight, "latestRep": rep,"latestDate": Date()]) { error in
                guard error == nil else {
                    print("記録更新時（種目更新）のエラー\(error!)")
                    return
                }
            }
            //記録を上書き
            db.collection("users").document(userID).collection("events").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep]) { error in
                guard error == nil else {
                    print("記録更新時のエラー\(error!)")
                    return
                }
            }
        }
    }
    //シェア
    func shareApp(){
        var window: UIWindow? {
            guard let scene = UIApplication.shared.connectedScenes.first,
                  let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                  let window = windowSceneDelegate.window else {
                return nil
            }
            return window
        }
        let productURL:URL = URL(string: "https://apps.apple.com/us/app/%E7%AD%8B%E3%83%88%E3%83%AC%E8%A8%98%E9%8C%B2-%E7%AD%8B%E8%82%89%E3%81%AE%E6%88%90%E9%95%B7%E3%82%92%E3%83%87%E3%83%BC%E3%82%BF%E5%8C%96-%E3%83%88%E3%83%AC%E3%83%BC%E3%83%8B%E3%83%B3%E3%82%B0%E8%A8%98%E9%8C%B2/id1622549301?itsct=apps_box_link&itscg=30200")!
        let av = UIActivityViewController(activityItems: [productURL],applicationActivities: nil)
        window?.rootViewController?.present(av, animated: true, completion: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            av.popoverPresentationController?.sourceView = window
            av.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width/2.1, y: UIScreen.main.bounds.height/1.3, width: 200, height: 200)
        }
    }
}
