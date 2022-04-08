//
//  ViewModel.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/03.
//

import Foundation
import Firebase

class ViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var records = [Record]()
    @Published var records3 = [Record]()
    @Published var records9 = [Record]()
    @Published var records27 = [Record]()
    @Published var weightArray = [Float]()
    @Published var maxWeight: Float = 0.0
    @Published var latestID: String = ""
    @Published var latestID3: String = ""
    @Published var latestID9: String = ""
    @Published var latestID27: String = ""
    @Published var oldRecord: Record?
    
    func updateEvent(event: Event, newName: String) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).setData(["name": newName])
    }
    
    func deleteEvent(event: Event) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).delete { error in
            self.events.removeAll { e in
                return e.id == event.id
            }
        }
    }
    
    func addEvent(_ name: String) {
        let db = Firestore.firestore()
        db.collection("user").addDocument(data: ["name": name, "latestWeight": 0, "latestRep": 0,]) { error in
            self.getEvent()
        }
    }
    
    func getEvent() {
        let db = Firestore.firestore()
        db.collection("user").getDocuments { snapshot, error in
            if let snapshot = snapshot{
                self.events = snapshot.documents.map { d in
                    return Event(id: d.documentID,
                                 name: d["name"] as? String ?? "",
                                 latestWeight: d["latestWeight"] as? Int ?? 0,
                                 latestRep: d["latestRep"] as? Int ?? 0)
                }
            }
        }
    }
    
    func getRecord(event: Event) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).collection("records").order(by: "date").getDocuments { (snapshot, error) in
            if let snapshot = snapshot{
                snapshot.documents.map { d in
                    self.latestID = d.documentID
                    let timeStamp: Timestamp = d["date"] as? Timestamp ?? Timestamp()
                    let date = timeStamp.dateValue()
                    if let newRecord = self.oldRecord {
                        var dateDifference = (Calendar.current.dateComponents([.day], from: newRecord.date, to: timeStamp.dateValue())).day! - 1
                        while dateDifference > 0 {
                            self.records.append(Record(id: UUID().uuidString, date: Date(timeInterval: TimeInterval(-60*60*24*dateDifference), since: date), weight: newRecord.weight, rep: newRecord.rep, dummy: true))
                            dateDifference -= 1
                        }
                    }
                    let record = Record(id: d.documentID, date: date, weight: d["weight"] as? Float ?? 0, rep: d["rep"] as? Int ?? 0, dummy: false)
                    self.oldRecord = record
                    self.records.append(record)
                }
                
                var dataCount = 0
                var totalWeight: Float = 0
                var totalRep = 0
                var remainder = self.records.count % 3
                var created = false
                self.records.forEach { record in
                    totalWeight += record.weight
                    totalRep += record.rep
                    dataCount += 1
                    if remainder != 0 && remainder == dataCount && created == false {
                        let recordID = UUID().uuidString
                        self.records3.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(dataCount), rep: totalRep/dataCount, dummy: false))
                        self.latestID3 = recordID
                        created = true
                        totalWeight = 0
                        totalRep = 0
                        dataCount = 0
                    }
                    if dataCount == 3 {
                        let recordID = UUID().uuidString
                        self.records3.append(Record(id: recordID, date: record.date, weight: totalWeight/3, rep: totalRep/3, dummy: false))
                        self.latestID3 = recordID
                        totalWeight = 0
                        totalRep = 0
                        dataCount = 0
                    }
                }
                
                dataCount = 0
                totalWeight = 0
                totalRep = 0
                remainder = self.records.count % 9
                created = false
                self.records.forEach { record in
                    totalWeight += record.weight
                    totalRep += record.rep
                    dataCount += 1
                    if remainder != 0 && remainder == dataCount && created == false {
                        let recordID = UUID().uuidString
                        self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(dataCount), rep: totalRep/dataCount, dummy: false))
                        self.latestID9 = recordID
                        created = true
                        totalWeight = 0
                        totalRep = 0
                        dataCount = 0
                    }
                    if dataCount == 9 {
                        let recordID = UUID().uuidString
                        self.records9.append(Record(id: recordID, date: record.date, weight: totalWeight/9, rep: totalRep/9, dummy: false))
                        self.latestID9 = recordID
                        totalWeight = 0
                        totalRep = 0
                        dataCount = 0
                    }
                }
                
                dataCount = 0
                totalWeight = 0
                totalRep = 0
                remainder = self.records.count % 27
                created = false
                self.records.forEach { record in
                    totalWeight += record.weight
                    totalRep += record.rep
                    dataCount += 1
                    if remainder != 0 && remainder == dataCount && created == false {
                        let recordID = UUID().uuidString
                        self.records27.append(Record(id: recordID, date: record.date, weight: totalWeight/Float(dataCount), rep: totalRep/dataCount, dummy: false))
                        self.latestID27 = recordID
                        created = true
                        totalWeight = 0
                        totalRep = 0
                        dataCount = 0
                    }
                    if dataCount == 27 {
                        let recordID = UUID().uuidString
                        self.records27.append(Record(id: recordID, date: record.date, weight: totalWeight/27, rep: totalRep/27, dummy: false))
                        self.latestID27 = recordID
                        totalWeight = 0
                        totalRep = 0
                        dataCount = 0
                    }
                }
                
                self.weightArray = snapshot.documents.map { d in
                    if self.maxWeight < d["weight"] as? Float ?? 0.0 {
                        self.maxWeight = d["weight"] as? Float ?? 0.0
                    }
                    return d["weight"] as? Float ?? 0.0
                }
            }
        }
        //recordsPer3Daysの作成手順
        //1.recordsをfor文に突っ込んでrecordごとに処理を行えるようにする
        //2.recordの情報のうち、weightとrepを受け取る受け皿作成
        //3.recordの情報を何本分受け取ったかカウントする受け皿作成
        //4.record3つ分の情報が溜まったら、3つ分weightとrepを凝縮してBar1本生成
        //5.最後に余った1、2個分の情報も使ってBar1本生成
    }
    
    func addRecord(event: Event, weight: Int, rep: Int) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).setData(["name":event.name, "latestWeight": weight, "latestRep": rep])
        db.collection("user").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep])
    }
}
