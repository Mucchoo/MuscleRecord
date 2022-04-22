//
//  ViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import SwiftUI
import Firebase

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
    @Published var isSigned = false
    
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
    
    func dateFormat(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: date)
    }
    
    func updateEvent(event: Event, newName: String) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).updateData(["name": newName]) { error in
            if let error = error {
                print("updateEvent中のエラー: \(error)")
            } else {
                print("updateEvent成功")
            }
        }
    }
    
    func deleteEvent(event: Event) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).delete() { error in
            if let error = error {
                print("deleteEvent中のエラー: \(error)")
            } else {
                print("deleteEvent成功")
            }
        }
    }
    
    func addEvent(_ name: String) {
        let db = Firestore.firestore()
        db.collection("user").document(name).setData(["latestWeight": 0, "latestRep": 0, "latestDate": Date(timeInterval: -60*60*24, since: .now)]) { error in
            if let error = error {
                print("addEvent中のエラー: \(error)")
            } else {
                print("addEvent成功")
            }
        }
    }
    
    func getEvent() {
        let db = Firestore.firestore()
        db.collection("user").getDocuments { snapshot, error in
            if let snapshot = snapshot{
                if let error = error {
                    print("getEvent中のエラー: \(error)")
                } else {
                    print("getEvent成功")
                    DispatchQueue.main.async {
                        self.events = snapshot.documents.map { d in
                            let timeStamp = d["latestDate"] as! Timestamp
                            return Event(id: d.documentID, latestWeight: d["latestWeight"] as! Float, latestRep: d["latestRep"] as! Int, latestDate: timeStamp.dateValue())
                        }
                    }
                }
            }
        }
    }
    
    func getRecord(event: Event) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).collection("records").order(by: "date").getDocuments { (snapshot, error) in
            if let snapshot = snapshot{
                if let error = error {
                    print("getRecord中のエラー: \(error)")
                } else {
                    print("getRecord成功")
                    DispatchQueue.main.async {
                        snapshot.documents.forEach { d in
                            self.latestID = d.documentID
                            let timeStamp: Timestamp = d["date"] as? Timestamp ?? Timestamp()
                            let date = timeStamp.dateValue()
                            if let newRecord = self.oldRecord {
                                var dateDifference = (Calendar.current.dateComponents([.day], from: newRecord.date, to: timeStamp.dateValue())).day! - 1
                                while dateDifference > 0 {
                                    self.records.append(Record(id: UUID().uuidString, date: Date(timeInterval: TimeInterval(-60*60*24*dateDifference), since: date), weight: newRecord.weight, rep: 0, dummy: true))
                                    dateDifference -= 1
                                }
                            }
                            let record = Record(id: d.documentID, date: date, weight: d["weight"] as? Float ?? 0, rep: d["rep"] as? Int ?? 0, dummy: false)
                            self.oldRecord = record
                            self.records.append(record)
                        }
                        
                        //取得した記録を元に3日、9日、27日平均に変換した配列を作る
                        for i in 1..<4{
                            var totalDate = 0
                            var totalWeight: Float = 0
                            var totalRep = 0
                            let period = Int(truncating: pow(3, i) as NSNumber)
                            let remainder = self.records.count % period
                            var created = false
                            self.records.forEach { record in
                                totalWeight += record.weight
                                totalRep += record.rep
                                totalDate += 1
                                if remainder != 0 && remainder == totalDate && created == false {
                                    let recordID = UUID().uuidString
                                    self.records3.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(totalDate), rep: totalRep/totalDate, dummy: false))
                                    self.latestID3 = recordID
                                    created = true
                                    totalWeight = 0
                                    totalRep = 0
                                    totalDate = 0
                                }
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
                        
                        //グラフの目盛り幅を決めるために重量の最大値を計算
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
    
    func addRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).setData(["latestWeight": weight, "latestRep": rep, "latestDate": Date()]) { error in
            if let error = error {
                print("addRecord(event)中のエラー: \(error)")
            } else {
                print("addRecord(event)成功")
            }
        }
        db.collection("user").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep]) { error in
            if let error = error {
                print("addRecord(record)中のエラー: \(error)")
            } else {
                print("addRecord(record)成功")
            }
        }
    }
    
    func updateRecord(event: Event, weight: Float, rep: Int) {
        let db = Firestore.firestore()
        
        db.collection("user").document(event.id).collection("records").order(by: "date", descending: true).limit(to: 1).getDocuments { snapshot, error in
            if let snapshot = snapshot {
                if let error = error {
                    print("updateRecord(delete)中のエラー: \(error)")
                } else {
                    print("updateRecord(delete)成功")
                    snapshot.documents.forEach { d in
                        let latestRecordID = d.documentID
                        db.collection("user").document(event.id).collection("records").document(latestRecordID).delete()
                    }
                }
            }
        }
        
        db.collection("user").document(event.id).setData(["latestWeight": weight, "latestRep": rep,"latestDate": Date()]) { error in
            if let error = error {
                print("updateRecord(event)中のエラー: \(error)")
            } else {
                print("updateRecord(event)成功")
            }
        }
        
        db.collection("user").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep]) { error in
            if let error = error {
                print("updateRecord(record)中のエラー: \(error)")
            } else {
                print("updateRecord(record)成功")
            }
        }
    }
}
