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

    func getData(_ event: String) {
        let db = Firestore.firestore()
        db.collection(event).getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot{
                    DispatchQueue.main.async {
                        self.events = snapshot.documents.map { d in
                            return Event(id: d.documentID,
                                         name: d["name"] as? String ?? "",
                                         latestWeight: d["latestWeight"] as? Int ?? 0,
                                         latestRep: d["latestRep"] as? Int ?? 0)
                        }
//                            let timeStamp: Timestamp = d["date"] as! Timestamp
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.dateFormat = "YY/MM/dd"
//                            let date: String = dateFormatter.string(from: timeStamp.dateValue())
                    }
                }
            } else {
                
            }
        }
    }
}
