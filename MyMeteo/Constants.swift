//
//  Constants.swift
//  MyMeteo
//
//  Created by Hermann Dorio on 16/11/2016.
//  Copyright © 2016 Hermann Dorio. All rights reserved.
//

import Foundation
import CoreData
import UIKit

typealias DownloadComplete = () -> () // create my typealias closure needed to be passed in argument each time i'm doing a url request to handle the end of the request
let URL_BASE = "http://api.openweathermap.org/data/2.5/forecast/daily?"
let APPID = "6244b881fddc9a5b34b875aeefde24ce" // id key to use api openweather
let CodeCITY = "Paris,fr"
let DEGREE_CELCIUS = "metric"
let NB_DAYS = "5"
let URL_BASE_IMG = "http://openweathermap.org/img/w/"

let FORECAST_DAILY_5_DAYS = "\(URL_BASE)q=\(CodeCITY)&cnt=\(NB_DAYS)&units=\(DEGREE_CELCIUS)&APPID=\(APPID)"




func getcontext () -> NSManagedObjectContext? {
    var context: NSManagedObjectContext?
    if #available(iOS 10.0, *) {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    } else {
        // iOS 9.0 and below - however you were previously handling it
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        let storeURL = docURL.appendingPathComponent("Model.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    
    }
    return context
} //func to use core data
