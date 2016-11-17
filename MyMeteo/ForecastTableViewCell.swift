//
//  ForecastTableViewCell.swift
//  MyMeteo
//
//  Created by Hermann Dorio on 17/11/2016.
//  Copyright © 2016 Hermann Dorio. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var imageforecast: UIImageView!
    @IBOutlet weak var jour: UILabel!
    
    func updateUI(forecast: DailyForecast){
        self.degree.text = "\(forecast.daytemp)°"
        self.jour.text = "\(forecast.thedate)"

        let url = URL(string: "\(URL_BASE_IMG)\(forecast.codeimage).png")
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url!)
                DispatchQueue.main.sync {
                    self.imageforecast.image = UIImage(data: data)
                    forecast.dateimage = self.imageforecast.image!
                }
            }catch{
                print("error download image in cell forecast")
            }
        }
        
    }

}
