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
                .fontWeight(.semibold)
                .padding(.bottom, 10)
                VStack(alignment: .leading,spacing: 6, content: {
                    if entry.lastThreeTasks.isEmpty{
                        Text("No tasks found")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }// fin if
                    else {
                        ForEach(entry.lastThreeTasks) { task in
                            HStack(spacing: 6) {
                                Button(intent: ToggleStateIntent(id: task.id)){
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(.plain)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.taskTitle)
                                        .font(.body) // Use font instead of textScale
                                        .lineLimit(1)
                                        .strikethrough(task.isCompleted, pattern: .solid, color: .primary)
                                    Divider()
                                }
                            }
                            if task.id != entry.lastThreeTasks.last?.id {
                                Spacer(minLength: 0)
                            }
                        }
                    }// fin else
                })// fin Vstack
                
            }//Termina Principal
            .containerBackground(.fill.tertiary,for: .widget)
            
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
