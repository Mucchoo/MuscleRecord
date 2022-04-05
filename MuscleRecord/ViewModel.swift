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
    
    func updateRecord(event: Event, weight: Int, rep: Int) {
        let db = Firestore.firestore()
        db.collection("user").document(event.id).setData(["name":event.name, "latestWeight": weight, "latestRep": rep])
    }
    
}

//                            let timeStamp: Timestamp = d["date"] as! Timestamp
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "YY/MM/dd"
//                            let date: String = dateFormatter.string(from: timeStamp.dateValue())
