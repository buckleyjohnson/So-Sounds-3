//
//  Constants.swift
//  Reverie
//
//  Created by David on 9/29/15.
//  Copyright © 2015 Reverie. All rights reserved.
//

import Foundation
import UIKit

//No UserProfile Constants
let kDefaultEmailForNoUser = "defaultNoUser@nouser.com"

//Internet status notification
let kInternetAvailable = "InternetAvailable"

// CoreData Constants
let kCoreDataUserInfo = "UserInfoCD"
let kCoreDataComfortSetting = "ComfortSettingCD"
let kCoreDataRoutine = "RoutineCD"

// UserInfo Profile Constants
let kUserInfo = "UserInfo"
let kUserFirstName = "FirstName"
let kUserLastName = "LastName"
let kUserGender = "Gender"
let kUserBirthday = "Birthday"
let kUserHeight = "Height"
let kUserWeight = "Weight"
let kUserLifeStyle = "LifeStyle"
let kUserSleepingPosition = "SleepingPosition"
let kUserTempurature = "Temperature"
let kUserFoundation = "Foundation"
let kUserMattress = "Mattress"
let kUserFirmness = "Firmness"
let kUserOccupants = "Occupants"
let kUserHoursOfSleep = "HoursOfSleep"
let kUserPhoneNumber = "PhoneNumber"
let kUserEmail = "EmailAddress"
let kUserPicture = "ProfilePicture"


//WarrentyInfo Constants
let kWarrentyInfo = "WarrentyInfo"
let kWarrentyFirstName = "firstName"
let kWarrentyLastName = "lastName"
let kWarrentyEmail = "email"
let kWarrentyPhoneNumber = "phoneNumber"
let kWarrentyAddress = "address"
let kWarrentyModel = "model"
let kWarrentySerialNumber = "serialNumber"

//Diagnostics Constants

//Saved Comfort Setting Constants
let kComfort = "ComfortSetting"
let kComfortName = "Name"
let kComfortHeadPosValue = "HeadPosValue"
let kComfortFootPosValue = "FootPosValue"
let kComfortLumbarPosValue = "LumbarPosValue"
let kComfortHeadMassageValue = "HeadMassageValue"
let kComfortFootMassageValue = "FootMassageValue"
let kComfortMassageTimer = "MassageTimer"
let kComfortMassageMode = "MassageMode"    //Stop, FullBody, Wave1, Wave2, Wave3, Wave4, Wave5
let kComfortEmailAddress = "EmailAddress"
let kComfortRoutineOnly = "RoutineOnly"

//Saved Routine Constants
let kRoutine = "Routine"
let kRoutineName = "Name"
let kRoutineComfortSettingIds = "ComfortSettings"
let kRoutineTimes = "Times"
let kRoutineEmailAddress = "EmailAddress"

//Saved Alarm Constants
let kAlarm = "Alarm"
let kAlarmEmailAddress = "EmailAddress"
let kAlarmTime = "Time"
let kAlarmIsEnabled = "Enabled"
let kAlarmDays = "Days"
let kAlarmType = "Type"
let kAlarmSnoozeEnabled = "Snooze"
let kAlarmComfortSetting = "ComfortSetting"
let kAlarmRoutine = "Routine"

//Massage Modes
enum MassageModes: String {
    case Stop = "Stop"
    case FullBody = "FullBody"
    case Wave1 = "Wave1"
    case Wave2 = "Wave2"
    case Wave3 = "Wave3"
    case Wave4 = "Wave4"
    case Wave5 = "Wave5"
    case None = "None"
}

//NSUser Defaults Bluetooth Constants
let kBTLESavedBeds = "BTLESavedBeds"    //will contain a dictionary of saved UUID beds and alternate names. Default is UUID
let kBTLEConnectBeds = "BTLEConnectBeds"    //beds to connect to

//Types of Presets
enum PresetType: String {
    case ComfortSetting = "ComfortSetting"
    case Routine = "Routine"
    case None = "None"
}

//Days of the week for alarms
enum DaysOfWeek: String {
    case Sunday = "Sunday"
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    static let allValues = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]
}

//Life Style Levels
enum LifeStyle: String {
    case SomeWhatActive = "Somewhat Active"
    case Active = "Active"
    case VeryActive = "Very Active"
    case Athletic = "Athletic"
    case NotActive = "Not Active"
    static let allValues = [SomeWhatActive, Active, VeryActive, Athletic, NotActive]
}

//Temperature Levels
enum Temperature: String {
    case Cold = "Cold"
    case Neutral = "Neutral"
    case Hot = "Hot"
    static let allValues = [Cold, Neutral, Hot]
}

//Sleeping Positions
enum SleepPositions: String {
    case Back = "Back"
    case Side = "Side"
    case Stomach = "Stomach"
    case TossAndTurn = "Toss & Turn"
    static let allValues = [Back, Side, Stomach, TossAndTurn]
}

//Foundation
enum Foundation: String {
    case Foundation3E = "3E"
    case Foundation5D = "5D"
    case Foundation7S = "7S"
    case Foundation8Q = "8Q"
    static let allValues = [Foundation3E, Foundation5D, Foundation7S, Foundation8Q]
}

//Mattress
enum Mattress: String {
    case DreamLite = "Dream Lite"
    case Dream = "Dream"
    case DreamSupreme = "Dream Supreme"
    case Other = "Other"
    static let allValues = [DreamLite, Dream, DreamSupreme, Other]
}

//Firmness
enum Firmness: String {
    case Soft = "Soft"
    case Medium = "Medium"
    case Firm = "Firm"
    static let allValues = [Soft, Medium, Firm]
}

//Occupants
enum Occupants: String {
    case Single = "Single"
    case Partner = "Partner"
    case Pets = "Pet(s)"
    static let allValues = [Single, Partner, Pets]
}

//Gender
enum Gender: String {
    case Male = "Male"
    case Female = "Female"
    static let allValues = [Male, Female]
}


//BTLE Module Types
enum BTLEModule: String {
    case BTLEOld108 = "BTLEOld108"
    case BTLENew108 = "BTLENew108"
    case BTLE110 = "BTLE110"
    case All = "All"
    static let allValues = [BTLEOld108, BTLENew108, BTLE110, All]
}

//Notification Center Constants
let kCameraStart = "CameraStart"
let kMoviePlayerStart = "MovieStart"
let kTimer = "Timer"

//Movement Times
let kMaxHeadTime: Double = 26.0
let kMaxFootTime: Double = 18.0
let kMaxHeadTime110: Double = 20.0
let kMaxFootTime110: Double = 20.0
let kMaxLumbarTime110: Double = 20.0

//Download and File Links               ///note, these constants are used in Music class but result is unused
let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

let songEnergizingSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Energizing_1hr.wav")
let songFocusedSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Focused_1hr.wav")
let songJourneySourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Journey.wav")
let songJazzSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Jazz.wav")
let songPeacefulSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Peaceful.wav")
let songPresentSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Present_1hr.wav")
let songRelaxingSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Relaxing.wav")
let songMeditationSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/Meditation.wav")
let songResonantSourceURL = URL(string:"http://www.sosoundsolutions.com/uploads/ios-app-assets/Resonant.wav")

let songSoSoundURL = Bundle.main.url(forResource: "SoChord", withExtension: "wav")
let songSoSoundFiveMinuteDemoURL = Bundle.main.url(forResource: "SO-Chair-5min-Demo-Ref-8-27-1", withExtension: "wav")

let v2SongEnergizingURL = documentsDirectoryURL.appendingPathComponent("Energizing_1hr.wav")
let v2SFocusedURL = documentsDirectoryURL.appendingPathComponent("Focused_1hr.wav")
let v2SJazzURL = documentsDirectoryURL.appendingPathComponent("Jazz.wav")
let v2SJourneyURL = documentsDirectoryURL.appendingPathComponent("Journey.wav")
let v2SPeacefulURL = documentsDirectoryURL.appendingPathComponent("SoPeaceful.wav")
let v2SPresentURL = documentsDirectoryURL.appendingPathComponent("Present_1hr.wav")
let v2SRelaxingURL = documentsDirectoryURL.appendingPathComponent("Relaxing.wav")
let v2SMeditationURL = documentsDirectoryURL.appendingPathComponent("Meditation.wav")
let v2SResonantURL = documentsDirectoryURL.appendingPathComponent("Resonant.wav")


// Sample music
let sampleMeditationURL = Bundle.main.url(forResource: "SoMeditation", withExtension: "wav")
let sampleFocusedURL = Bundle.main.url(forResource: "SoFocused", withExtension: "wav")
let sampleEnergizingURL = Bundle.main.url(forResource: "SoEnergizing", withExtension: "wav")
let sampleJazzURL = Bundle.main.url(forResource: "SoJazz", withExtension: "wav")
let sampleJourneyURL = Bundle.main.url(forResource: "SoJourney", withExtension: "wav")
let samplePeacefulURL = Bundle.main.url(forResource: "SoPeaceful", withExtension: "wav")
let samplePresentURL = Bundle.main.url(forResource: "SoPresent", withExtension: "wav")
let sampleRelaxingURL = Bundle.main.url(forResource: "SoRelaxing", withExtension: "wav")
let sampleResonantURL = Bundle.main.url(forResource: "SoResonant", withExtension: "wav")


// old files to be removed
let toRemoveSongEnergizingURL = documentsDirectoryURL.appendingPathComponent("Energizing.wav")
let toRemoveSongFocusedURL = documentsDirectoryURL.appendingPathComponent("Focused.wav")
let toRemoveSongPresentURL = documentsDirectoryURL.appendingPathComponent("Present.wav")

// For development environment
////
//let songEnergizingSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Energizing_1hr.mp3")
//let songFocusedSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Focused_1hr.mp3")
//let songJourneySourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Journey.mp3")
//let songJazzSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Jazz.mp3")
//let songPeacefulSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Peaceful.mp3")
//let songPresentSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Present_1hr.mp3")
//let songRelaxingSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Relaxing.mp3")
//let songMeditationSourceURL = URL(string: "http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Meditation.mp3")
//let songResonantSourceURL = URL(string:"http://www.sosoundsolutions.com/uploads/ios-app-assets/mp3/Resonant.mp3")
//
//let v2SongEnergizingURL = documentsDirectoryURL.appendingPathComponent("Energizing_1hr.mp3")
//let v2SFocusedURL = documentsDirectoryURL.appendingPathComponent("Focused_1hr.mp3")
//let v2SJazzURL = documentsDirectoryURL.appendingPathComponent("Jazz.mp3")
//let v2SJourneyURL = documentsDirectoryURL.appendingPathComponent("Journey.mp3")
//let v2SPeacefulURL = documentsDirectoryURL.appendingPathComponent("Peaceful.mp3")
//let v2SPresentURL = documentsDirectoryURL.appendingPathComponent("Present_1hr.mp3")
//let v2SRelaxingURL = documentsDirectoryURL.appendingPathComponent("Relaxing.mp3")
//let v2SMeditationURL = documentsDirectoryURL.appendingPathComponent("Meditation.mp3")
//let v2SResonantURL = documentsDirectoryURL.appendingPathComponent("Resonant.mp3")










