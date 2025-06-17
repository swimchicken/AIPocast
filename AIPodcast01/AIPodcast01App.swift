//
//  AIPodcast01App.swift
//  AIPodcast01
//
//  Created by swimchichen on 2025/5/2.
//

import SwiftUI
import CoreData

@main
struct AIPodcast01App: App {
    // Core Data 容器
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                           persistenceController.container.viewContext)
        }
    }
}
