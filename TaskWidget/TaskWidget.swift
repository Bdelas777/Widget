//
//  TaskWidget.swift
//  TaskWidget
//
//  Created by Alumno on 14/08/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
            TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
        }


    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
            let entry = TaskEntry(lastThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
            completion(entry)
        }


    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> ()) {
        // FETCH DATA
        let latestTasks = Array(TaskDataModel.shared.tasks.prefix(3))
        let latestEntries = [TaskEntry(lastThreeTasks: latestTasks)]
        let timeline = Timeline(entries: latestEntries, policy: .atEnd)
        completion(timeline)
    }

}

struct TaskEntry: TimelineEntry {
    let date: Date = .now
    var lastThreeTasks: [TaskModel]
}

struct TaskWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Tasks")
                .fontWeight(.bold)
                .padding(.bottom, 10)
                VStack(alignment: .leading, spacing: 0) {
                    if entry.lastThreeTasks.isEmpty {
                        Text("No tasks found")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    }else{
                        ForEach(entry.lastThreeTasks) {
                            task in
                            HStack(spacing: 6){
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.taskTitle)
                                        .font(.body)
                                        .lineLimit(1)
                                        .strikethrough(task.isCompleted, pattern: .solid, color: .primary)
                                                                Divider()
                                                            }
                            }
                            if task.id != entry.lastThreeTasks.last?.id {
                                                        Spacer(minLength: 0)
                                                    }

                        }
                    }// FIn else
                }        // VSTAck de tareas
            }//Termina Principal
            
        }
    }
}

struct TaskWidget: Widget {
    let kind: String = "TaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TaskWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TaskWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Task Widget")
        .description("This is an example of interative widget.")
    }
}

#Preview(as: .systemSmall) {
    TaskWidget()
} timeline: {
    TaskEntry(lastThreeTasks: TaskDataModel.shared.tasks)
}
