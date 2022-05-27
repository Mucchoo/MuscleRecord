//
//  ComposeMailData.swift
//  MuscleRecord
//
//  Created by Musa Yazuju on 2022/04/24.
//

import Foundation
//問い合わせメールの内容
struct Email {
  let subject: String
  let recipients: [String]?
  let message: String
}
