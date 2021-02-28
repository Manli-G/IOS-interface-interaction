//
//  FriendsTableViewController.swift
//  CoreDataFriends
//
//  Created by gaomanli on 24/03/2020.
//  Copyright © 2020 gaomanli. All rights reserved.
//

import UIKit
import CoreData

class FriendsTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
}


class FriendsTableViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    
    //outlets
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
    var friendManagedObject : Friends! = nil
    var entity: NSEntityDescription? = nil
    var frc : NSFetchedResultsController <NSFetchRequestResult>! = nil
    
    
    func makeRequest() -> NSFetchRequest <NSFetchRequestResult>{
        let request = NSFetchRequest <NSFetchRequestResult> (entityName:"Friends")
        
        let sorter = NSSortDescriptor(key:"name",ascending:true)
        
        // filter if you need
        //let predicate = NSPredicate(format:"%K == %@","name","sabin")
        // request.predicate = predicate
        request.sortDescriptors = [sorter]
        
        return request
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make the frc and fetch
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self as? NSFetchedResultsControllerDelegate
        
        do {
            try frc.performFetch()
        }catch{
            print("frc cannot fetch")
        }
        print(NSHomeDirectory())
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return frc.sections![section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sigleCell", for: indexPath as IndexPath)as!FriendsTableViewCell

        // Configure the cell...
        // get from frc the managed object at indexPath
        friendManagedObject = frc.object(at: indexPath) as? Friends
        // Fill the cell
        cell.nameLabel?.text = friendManagedObject.name
        cell.phoneLabel?.text = friendManagedObject.phone
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(friendManagedObject.image!)
        var green = UIColor(red: 240.0/255, green: 239.0/255, blue: 231.0/255, alpha: 1.0)
        
        cell.iconImage?.image = UIImage(contentsOfFile: imagePath)
        //cell.imageView?.layer.cornerRadius = (cell.imageView?.bounds.width)! / 2
        //cell.imageView?.layer.masksToBounds = true
        cell.iconImage?.layer.cornerRadius = (cell.iconImage)!.frame.size.width / 2;
        //cell.iconImage?.layer.cornerRadius = 20.0;
        cell.iconImage?.clipsToBounds = true;
        cell.iconImage?.layer.borderWidth = 5.0
        cell.iconImage?.layer.borderColor = green.cgColor
        
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get friendManagedObject of indexPath and delete
            friendManagedObject = frc.object(at: indexPath) as! Friends
            context.delete(friendManagedObject)
            
            //context save
            do{try context.save()}
            catch{}
            
            //frc perform fetch
            do{try frc.performFetch()}
            catch{}
            
            //reload
            tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
         
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSegue"{
            
            // get friendManagedObject from frc
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            friendManagedObject = frc.object(at: indexPath!)as!Friends
            
            // Get the new view controller using segue.destination.
            let vc = segue.destination as! AddFriendViewController
            
            // Pass the selected object to the new view controller.
            vc.friendManagedObject = friendManagedObject
            
        }
    }
}
    



