//
//  CalorieTrackerApp.swift
//  CalorieTracker
//
//  Created by Andrew Chang on 3/28/23.
//

import SwiftUI
import Firebase




@main
struct CalorieTrackerApp: App {

    init(){
        FirebaseApp.configure()
    }    
    var body: some Scene
    {
        
        WindowGroup
        {
            ContentView()
        }
    }
}
