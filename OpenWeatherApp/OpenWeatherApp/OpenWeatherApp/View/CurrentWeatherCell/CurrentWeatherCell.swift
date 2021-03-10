//
//  CurrentWeatherCell.swift
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/4/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var descriptinLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(cityWeather:List) {
        self.cityLabel.text = cityWeather.name
        self.minLabel.text = "\(cityWeather.main.tempMin)"
        self.maxLabel.text = "\(cityWeather.main.tempMax)"
        self.windLabel.text = "\(cityWeather.wind.speed)"
        self.descriptinLabel.text = cityWeather.weather.first?.weatherDescription
    }
    
}
