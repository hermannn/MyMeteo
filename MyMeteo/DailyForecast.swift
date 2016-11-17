//
//  DailyForecast.swift
//  MyMeteo
//
//  Created by Hermann Dorio on 17/11/2016.
//  Copyright © 2016 Hermann Dorio. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DailyForecast {
    
    private var _cloud:Double!
    private var _thedate:String!
    private var _climatetat:String!
    private var _daytemp:Double!
    private var _mintemp:Double!
    private var _maxtemp:Double!
    private var _pressure:Double!
    private var _humidity:Double!
    private var _speed:Double!
    private var _soirtemp:Double!
    private var _matintemp:Double!
    private var _ville:String!
    private var _dateimage:NSObject?
    private var _description:String!
    private var _codeimage:String! //get the code image that we are gonna use to download image when we will update the ui
    
    
    var codeimage:String {
        if _codeimage == nil{
            _codeimage = ""
        }
        return _codeimage
    }

    
    var dateimage:NSObject? {
        get {
            if _dateimage == nil {
                return nil
            }
            return _dateimage
        }
        set{
            _dateimage = newValue
        }
    }
    
    var description:String {
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var thedate:String {
        get {
            if _thedate == nil {
                _thedate = ""
            }
            return _thedate
        }
        set {
            _thedate = newValue
        }
    }
  
    var cloud:Double {
        if _cloud == nil {
            _cloud = 0
        }
        return _daytemp
    }
    
    var daytemp:Double {
        if _daytemp == nil {
            _daytemp = 0
        }
        return _daytemp
    }
    
    var mintemp:Double {
        if _mintemp == nil {
            _mintemp = 0
        }
        return _mintemp
    }
    
    var maxtemp:Double {
        if _maxtemp == nil {
            _maxtemp = 0
        }
        return _maxtemp
    }
    
    var pressure:Double {
        if _pressure == nil {
            _pressure = 0
        }
        return _pressure
    }
    
    var humidity:Double {
        if _humidity == nil {
            _humidity = 0
        }
        return _humidity
    }
    
    var speed:Double {
        if _speed == nil {
            _speed = 0
        }
        return _speed
    }
    
    var soirtemp:Double {
        if _soirtemp == nil {
            _soirtemp = 0
        }
        return _soirtemp
    }
    
    var matintemp:Double {
        if _matintemp == nil {
            _matintemp = 0
        }
        return _matintemp
    }
    
    var ville:String {
        if _ville == nil {
            _ville = ""
        }
        return _ville
    }

    var climatetat:String {
        if _climatetat == nil {
            _climatetat = ""
        }
        return _climatetat
    }
    

    //init dailyforecast with core data
    init(dataforecast: NSManagedObject) {
        if let ville = dataforecast.value(forKey: "ville") as? String {
            self._ville = ville
        }
        if let tempmax = dataforecast.value(forKey: "tempmax") as? Double {
          self._maxtemp = tempmax
        }
        if let tempmin = dataforecast.value(forKey: "tempmin") as? Double {
            self._mintemp = tempmin
        }
        if let daytemp = dataforecast.value(forKey: "daytemp") as? Double {
            self._daytemp = daytemp
        }
        if let tempmin = dataforecast.value(forKey: "soirtemp") as? Double {
            self._soirtemp = tempmin
        }
        if let pressure = dataforecast.value(forKey: "pression") as? Double {
            self._pressure = pressure
        }
        if let humide = dataforecast.value(forKey: "humidite") as? Double {
            self._humidity = humide
        }
        if let speed = dataforecast.value(forKey: "vitessevent") as? Double {
            self._speed = speed
        }
        if let date = dataforecast.value(forKey: "date") as? String {
            self._thedate = date
        }
        if let climatetat = dataforecast.value(forKey: "etatclimat") as? String {
            self._climatetat = climatetat
        }
        if let desc = dataforecast.value(forKey: "desc") as? String {
            self._description = desc
        }
    }
    
    init(weatherData: Dictionary<String, AnyObject>, nameCity: String) {
        self._ville = nameCity
        if let cloudpourcent = weatherData["clouds"] as? Double {
            self._cloud = cloudpourcent
        }
        if let temp = weatherData["temp"] as? Dictionary<String, AnyObject> {
            print("\(temp)")
            if let day = temp["day"] as? Double {
                self._daytemp = Double(round(day))
            }
            if let max = temp["max"] as? Double {
                self._maxtemp = Double(round(max))
            }
            if let min = temp["min"] as? Double {
                self._mintemp = Double(round(min))
            }
            if let morn = temp["morn"] as? Double {
                self._matintemp = Double(round(morn))
            }
            if let night = temp["night"] as? Double {
                self._soirtemp = Double(round(night))
            }
        }
        if let presseurehpa = weatherData["pressure"] as? Double{
            self._pressure = presseurehpa
        }
        if let humiditypourcent = weatherData["humidity"] as? Double{
            self._humidity = humiditypourcent
        }
        if let speedms = weatherData["speed"] as? Double{
            
            let speedkmh = speedms * 3.6 //convert value m/s into km/h
            self._speed = Double(round(speedkmh))
        }
        if let date = weatherData["dt"] as? Double {
            //convert date in day
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.locale = NSLocale(localeIdentifier: "en_UK") as Locale! //day in english
            let mdate = Date(timeIntervalSince1970: date)
            let day = dateFormatter.string(from: mdate)
            self._thedate = day
        }
        
        if let weather = weatherData["weather"] as? [Dictionary<String, AnyObject>] {
            if let stateclimat = weather[0]["main"] as? String {
                self._climatetat = stateclimat
            }
            if let  desc = weather[0]["description"] as? String {
                self._description = desc
            }
            if let codeimage = weather[0]["icon"] as? String {
                self._codeimage = codeimage
            }
        }
        saveinCoreData()
    }

    
    func saveinCoreData(){
            let context = getcontext()
            let newForecast = NSEntityDescription.insertNewObject(forEntityName: "Forecast", into: context!)
            
            newForecast.setValue(self.daytemp, forKey: "daytemp")
            newForecast.setValue(self._description, forKey: "desc")
            newForecast.setValue(self._cloud, forKey: "cloud")
            newForecast.setValue(self.climatetat, forKey: "etatclimat")
            newForecast.setValue(self._thedate, forKey: "date")
            newForecast.setValue(self._speed, forKey: "vitessevent")
            newForecast.setValue(self._humidity, forKey: "humidite")
            newForecast.setValue(self._pressure, forKey: "pression")
            newForecast.setValue(self._matintemp, forKey: "matintemp")
            newForecast.setValue(self._soirtemp, forKey: "soirtemp")
            newForecast.setValue(self._mintemp, forKey: "tempmin")
            newForecast.setValue(self._maxtemp, forKey: "tempmax")
            newForecast.setValue(self._ville, forKey: "ville")
        
        do {
            try context?.save()
        }catch{
            print("save failed")
        }
        
    }
    
}
