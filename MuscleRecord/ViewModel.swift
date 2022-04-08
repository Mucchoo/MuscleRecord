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
    @Published var weightArray = [Float]()
    @Published var maxWeight: Float = 0.0
    @Published var latestID: String = ""
    @Published var newRecord: Record?

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
                    if let newRecord = self.newRecord {
                        var dateDifference = (Calendar.current.dateComponents([.day], from: newRecord.date, to: timeStamp.dateValue())).day! - 1
                        while dateDifference > 0 {
                            self.records.append(Record(id: UUID().uuidString, date: Date(timeInterval: TimeInterval(-60*60*24*dateDifference), since: date), weight: newRecord.weight, rep: newRecord.rep, dummy: true))
                            dateDifference -= 1
                        }
                    }
                    let record = Record(id: d.documentID, date: date, weight: d["weight"] as? Float ?? 0, rep: d["rep"] as? Int ?? 0, dummy: false)
                    self.newRecord = record
                    self.records.append(record)
                }
                self.weightArray = snapshot.documents.map { d in
                    if self.maxWeight < d["weight"] as? Float ?? 0.0 {
                        self.maxWeight = d["weight"] as? Float ?? 0.0
                    }
                    return d["weight"] as? Float ?? 0.0
                            
                }
            }
        }
    }
    
    func addRecord(event: Event, weight: Int, rep: Int) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).setData(["name":event.name, "latestWeight": weight, "latestRep": rep])
        db.collection("user").document(event.id).collection("records").addDocument(data: ["date": Date(), "weight": weight, "rep": rep])
    }
}
