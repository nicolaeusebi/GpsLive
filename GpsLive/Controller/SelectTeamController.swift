//
//  SelectTeamController.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 29/11/2018.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import UIKit

class SelectTeamController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tblTeams: UITableView!
    
    var teams: [TeamInfo] = []
    var parentController: MainController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblTeams.dataSource = self
        tblTeams.delegate = self
        tblTeams.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblTeams.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamCell
        
        let team = teams[(indexPath as NSIndexPath).row]
        cell.lblName.text = team.Name.uppercased()
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let team = teams[(indexPath as NSIndexPath).row]
        SharedInfo.TeamID = team.Team_ID
        SharedInfo.TeamName = team.Name
        if parentController != nil {
            parentController?.teamSelected()
        }
        self.dismiss(animated: true, completion: nil)
    }

}
