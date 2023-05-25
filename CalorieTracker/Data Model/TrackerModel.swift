//
//  TrackerModel.swift
//  CalorieTracker
//
//  Created by Andrew Chang on 3/28/23.
//

import Foundation
import SwiftUI


    struct Tracker
    {
        //---------------User Profile-------------//
        var goalWeight: Int = 185
        var weightTracker: Bool = false
        //App States
        //macro = 1
        //AddFood = 2
        //Pantry = 3
        var ballView: Bool = true
        var goalView: Bool = false
        var addFood: Bool = false
        var todayMeals: Bool = false
        var detailedView: Bool = false
        var justDeleted: Bool = false

        
        
        var size: CGFloat
        var calories: Int
        var goalStatus: Color
        var goal: Int
        var state: String = "sad"
        let maxSize:CGFloat = 380
        
        //program: 0 = cut, 1 = bulk
        var program: Int
        
        var mealView: Bool = false
        
        var selectedMeal: Int = 0
        
        
    
        var streak = UserDefaults.standard.integer(forKey: "streak")
        var lastTimeAdded = UserDefaults.standard.object(forKey: "lastTimeAdded") as? Date
        
        struct meal: Identifiable
        {
            var id: Int
            var calories: Int
            var protein: Int
            var carbs: Int
            var fat: Int
            var name: String
            var status: Color
            var days: Double
            var fullDate: Date
        }
        
        struct day: Identifiable
        {
            var id: Date
            var calories: Int
            var protein: Int
            var carbs: Int
            var fat: Int
            var color: String
            
        }
        
        var totalProtein: Int = 0
        var proteinGoal: Int = 180
        
        var totalCarbs: Int = 0
        var totalFat: Int = 0
        
        var todaymeals: Array<meal>
        var archivedmeals: Array<meal>
        
        mutating func deleteMeal(index: Int)
        {
            //min size = 100
            print(index)
            var changeCals = todaymeals[index].calories
            let excess = calories-goal
            
            
            if calories-changeCals<100
            {
                size = 100
            }
            else
            {
                size -= CGFloat(changeCals/(goal/280))
            }

            
   
            calories -= todaymeals[index].calories

            totalProtein -= todaymeals[index].protein
            totalCarbs -= todaymeals[index].carbs
            totalFat -= todaymeals[index].fat
            todaymeals.remove(at: index)
            print("deleted")
        }
        
        mutating func toggleWeightTracker()
        {
            weightTracker.toggle()
        }
        
        mutating func toggleJustDeleted()
        {
            justDeleted.toggle()
        }
        
        mutating func notJustDeleted()
        {
            justDeleted = false
        }
        
        mutating func reset()
        {
            ballView = true
            goalView = false
            addFood = false
            detailedView = false
            mealView = false
        }
        
        mutating func openGoalView()
        {
            ballView = false
            goalView = true
        }
        mutating func closeGoalView()
        {
            ballView = true
            goalView = false
        }
        
        mutating func openAddFoodView()
        {
            ballView = false
            addFood = true
        }
        mutating func closeAddFoodView()
        {
            ballView = true
            addFood = false
        }
        
        mutating func openTodayMeals()
        {
            ballView = false
            todayMeals = true
        }
        mutating func closeTodayMeals()
        {
            ballView = true
            todayMeals = false
        }
        
        mutating func openDetailedView()
        {
            todayMeals = false
            detailedView = true
        }
        mutating func closeDetailedView()
        {
            todayMeals = true
            detailedView = false
        }
        
        mutating func closeDetailedViewBall()
        {
            ballView = true
            detailedView = false
        }
        
        mutating func setSelectedMeal(id: Int)
        {
            for i in 0..<todaymeals.count
            {
                if todaymeals[i].id == id
                {
                    selectedMeal = i
                }
            }
        }
        
        mutating func addMeal(cals: Int, protein: Int, carbs: Int, fat: Int, name: String, status: Color, days: Double, fullDate: Date)
        {
            let newMeal = meal(id: todaymeals.count, calories: cals, protein: protein, carbs: carbs, fat: fat, name: name, status: goalStatus, days: days, fullDate: fullDate)
            calories += cals
            if size+CGFloat(cals/(goal/300)) <= maxSize
            {
                size += CGFloat(cals/(goal/300))
            }
            else
            {
                size = maxSize
            }
            totalProtein += newMeal.protein
            totalCarbs += newMeal.carbs
            totalFat += newMeal.fat
            todaymeals.append(newMeal)
            addFood = false
            ballView = true
        }
        
        mutating func addToArchive(cals: Int, protein: Int, carbs: Int, fat: Int, name: String, days: Double, fullDate: Date)
        {
            let newMeal = meal(id: archivedmeals.count, calories: cals, protein: protein, carbs: carbs, fat: fat, name: name, status: goalStatus, days: days, fullDate: fullDate)
            archivedmeals.append(newMeal)
        }
    
        
        mutating func checkSize()
        {
            if program == 0
            {
                if calories <= Int(0.4*Double(goal))
                {
                    goalStatus = Color("Green")
                    state = "happy"
                }
                
                else if calories <= Int(Double(goal))
                {
                    goalStatus = Color("Yellow")
                    state = "mid"
                }
                
                else if calories >= Int(Double(goal))
                {
                    goalStatus = Color("Red")
                    state = "sad"
                }
            }
            
            else
            {
                if calories <= Int(0.5*Double(goal))
                {
                    goalStatus = Color("Red")
                    state = "sad"
                }
                
                else if calories < Int(Double(goal))
                {
                    goalStatus = Color("Yellow")
                    state = "mid"
                }
                
                else if calories >= goal
                {
                    goalStatus = Color("Green")
                    state = "happy"
                }
            }
            
        }
    }
    
    
    
