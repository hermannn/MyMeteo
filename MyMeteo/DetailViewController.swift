//
//  DetailViewController.swift
//  MyMeteo
//
//  Created by Hermann Dorio on 17/11/2016.
//  Copyright © 2016 Hermann Dorio. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var forecastdetail:DailyForecast?
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var ville: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var vitesseventkmh: UILabel!
    @IBOutlet weak var humiditepourcent: UILabel!
    @IBOutlet weak var soirtemp: UILabel!
    @IBOutlet weak var pressurehpa: UILabel!
    @IBOutlet weak var matintemp: UILabel!
    @IBOutlet weak var tempmin: UILabel!
    @IBOutlet weak var tempmax: UILabel!
    @IBOutlet weak var stateclimat: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var degreeDay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let forecast = forecastdetail {
            updateUI(forecast: forecast)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(forecast: DailyForecast){
        self.desc.text = forecast.description
        self.degreeDay.text = "\(forecast.daytemp)°"
        self.humiditepourcent.text = "\(forecast.humidity)%"
        self.pressurehpa.text = "\(forecast.pressure)hpa"
        self.soirtemp.text = "\(forecast.soirtemp)°"
        self.matintemp.text = "\(forecast.matintemp)°"
        self.vitesseventkmh.text = "\(forecast.speed)km/h"
        self.tempmin.text = "\(forecast.mintemp)"
        self.tempmax.text = "\(forecast.maxtemp)"
        self.image.image = forecast.dateimage as? UIImage
        self.stateclimat.text = "\(forecast.climatetat)"
        self.ville.text = "\(forecast.ville)"
        self.date.text = "\(forecast.thedate)"
    }
    

}
