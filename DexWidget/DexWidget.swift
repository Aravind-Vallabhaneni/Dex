//
//  DexWidget.swift
//  DexWidget
//
//  Created by Aravind vallabhaneni on 04/08/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.placeHolder
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry.placeHolder
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry.placeHolder
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let name: String
    let types: [String]
    let sprite: Image
    
    static var placeHolder: SimpleEntry {
        SimpleEntry(date: .now, name: "bulbasuar", types: ["poison"], sprite: Image(.bulbasaur))
    }
    
    static var placeHolder2: SimpleEntry {
        SimpleEntry(date: .now, name: "bulbasuar2", types: ["poison"], sprite: Image(.mew))
    }
}

struct DexWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            entry.sprite
        }
    }
}

struct DexWidget: Widget {
    let kind: String = "DexWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DexWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DexWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    DexWidget()
} timeline: {
    SimpleEntry.placeHolder
    SimpleEntry.placeHolder2
}
