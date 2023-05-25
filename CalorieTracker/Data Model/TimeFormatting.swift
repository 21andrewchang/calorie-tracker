//
//  TimeFormatting.swift
//  Ongry
//
//  Created by Andrew Chang on 4/1/23.
//

import Foundation

//
func getTimeDays(date:Date)->Double
{
    let minutes = Double(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    return days
}

func getTimeSeconds(date:Date)->Double
{
    let seconds = Double(-date.timeIntervalSinceNow)

    return seconds
}

func getDate(date:Date)->String
{
    let today = date
    let formatter1 = DateFormatter()
    formatter1.dateStyle = .short
    
    return formatter1.string(from: today)
}

func getTime(date:Date)->String
{
    let today = date
    let formatter1 = DateFormatter()
    formatter1.timeStyle = .medium
    
    return formatter1.string(from: today)
}

func calcDaysBetween(start: Date, endDate: Date)->Int
{
    let minutes = Int(-start.timeIntervalSince(endDate))/60
    let hours = minutes/60
    let days = hours/24
    return days
}

func calcSecondsBetween(start: Date, endDate: Date)->Int
{
    let seconds = Int(-start.timeIntervalSince(endDate))
    return seconds
}


func calcTimeSince(date: Date)->String
{
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    
    if minutes < 120
    {
        return "\(minutes) minutes ago"
    }
    else if minutes >= 120 && hours < 48
    {
        return "\(hours) hours ago"
    }
    else
    {
        return "\(days) days ago"
    }
}
