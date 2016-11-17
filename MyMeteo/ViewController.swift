//
//  ViewController.swift
//  MyMeteo
//
//  Created by Hermann Dorio on 16/11/2016.
//  Copyright © 2016 Hermann Dorio. All rights reserved.
//

import UIKit
import AlamofireDomain
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mytableview: UITableView!
    var listForecast = [DailyForecast]() //list of forecast
    var mainForecast:DailyForecast! //forecast of the current day
    @IBOutlet weak var degreeMainView: UILabel!
    @IBOutlet weak var villeMainView: UILabel!
    @IBOutlet weak var etatclimatMainView: UILabel!
    @IBOutlet weak var imageMainView: UIImageView!
    @IBOutlet weak var dateMainView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mytableview.delegate = self
        self.mytableview.dataSource = self
        self.mytableview.tableFooterView = UIView(frame: CGRect.zero) // remove the empty cell
        self.downloadForecast {
            self.UpdateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func  deletealldata () {
        let context = getcontext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        
        do{
            let results = try context?.fetch(request)
            
            if (results?.count)! > 0 {
                for result in results as! [NSManagedObject] {
                    context?.delete(result)
                }
            }
        }catch{
            print("error delete data")
        }

    }
    
    func fetchdata(){
        let context = getcontext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
        
        do{
            var results = try context?.fetch(request)
            if (results?.count)! > 0 {
                let forecast = DailyForecast(dataforecast: results?.first as! NSManagedObject)
                mainForecast = forecast //update mainforecast
                results?.remove(at: 0)
                self.listForecast.removeAll()
                for result in results as! [NSManagedObject] {
                    let forecastelem = DailyForecast(dataforecast: result)
                    self.listForecast.append(forecastelem)
                }
                self.UpdateUI()
            }
        }catch{
            print("error fetch data")
        }

    }
    
    
    
    func downloadForecast (completed: @escaping DownloadComplete) {
        let currenturl = URL(string: FORECAST_DAILY_5_DAYS)!
        
        AlamofireDomain.request(currenturl).responseJSON { (response) in
            if response.result.error != nil {
                //display data save in core data handle offline mode
                self.fetchdata()
            }
            else{
                self.deletealldata()
                let result = response.result
                if let dict = result.value as? Dictionary<String, AnyObject>{
                    if let city = dict["city"] as? Dictionary<String, AnyObject>{
                        if let namecity = city["name"] as? String {
                            if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                                for elem in list {
                                    let forecast = DailyForecast(weatherData: elem, nameCity: namecity)
                                    self.listForecast.append(forecast)
                                }
                                self.mainForecast = self.listForecast.first //first elem
                                self.mainForecast.thedate = "today"
                                self.listForecast.remove(at: 0) // delete the first elem because we will display it in uiview not in our uitableview
                            }
                        }
                    }
                }
                completed()
            }
            
        }
    }
    
    func UpdateUI () {
        UpdateMainView()
        self.mytableview.reloadData()
    }
    
    func UpdateMainView () {
        
        self.degreeMainView.text = "\(mainForecast.daytemp)°"
        self.villeMainView.text = "\(mainForecast.ville)"
        self.etatclimatMainView.text = "\(mainForecast.climatetat)"
        self.dateMainView.text = "\(mainForecast.thedate)"
        //download image
        let url = URL(string: "\(URL_BASE_IMG)\(mainForecast.codeimage).png")!
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url)
                DispatchQueue.main.sync {
                    self.imageMainView.image = UIImage(data: data) // we go back to the main thread to update the image
                    self.mainForecast.dateimage = self.imageMainView.image
                }
            }catch{
                print("error dl image ")
            }
        }
    }
    
    @IBAction func PressedMainView(_ sender: AnyObject) {
     self.performSegue(withIdentifier: "DetailView", sender: mainForecast)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailView" {
            if let vc = segue.destination as? DetailViewController {
                if let mforecastdetail = sender as? DailyForecast{
                    vc.forecastdetail = mforecastdetail
                }
            }
        }
    }
    
    
    //tableview function
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = mytableview.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell{
            cell.updateUI(forecast: self.listForecast[indexPath.row])
            return cell
        }
        return ForecastTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let forecastselect = self.listForecast[indexPath.row]
        self.performSegue(withIdentifier: "DetailView", sender: forecastselect)
    }
    


}

