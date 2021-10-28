//
//  ViewController.swift
//  my-sky
//
//  Created by Matthew Chute on 2021-09-01.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url: String = "https://api.sunrise-sunset.org/json?lat=49.246292&lng=-123.116226"
        let sunrise_time = getData(from: url)
        lbl.text = "Sunrise is at " + sunrise_time + " UTC"
    }
    
    private func getData(from url: String) -> String {
        var returnData: String = ""
        var waiting: Bool = false
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("error")
                return
            }
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else {
                return
            }
            print(json.status)
            returnData = json.results.sunrise
            waiting = true
        }).resume()
        while !waiting {
        }
        return returnData
    }
}

struct Response: Codable {
    let results: MyResult
    let status: String
}

struct MyResult: Codable {
    let sunrise: String
    let sunset: String
    let solar_noon: String
    let day_length: String
    let civil_twilight_begin: String
    let civil_twilight_end: String
    let nautical_twilight_begin: String
    let nautical_twilight_end: String
    let astronomical_twilight_begin: String
    let astronomical_twilight_end: String
}
