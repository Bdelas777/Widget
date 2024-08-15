//
//  TaskModel.swift
//  Widget
//
//  Created by Alumno on 14/08/24.
//

import SwiftUI

struct TaskModel: Identifiable{
    var id: String = UUID().uuidString
    var taskTitle: String
    var isCompleted: Bool = false
}
class TaskDataModel{
    static let shared = TaskDataModel()
    
    var tasks: [TaskModel] = [
        .init(taskTitle: "Do Homework"),
        .init(taskTitle: "Practice Swift"),
        .init(taskTitle: "Learn Widget "),
    ]
}

