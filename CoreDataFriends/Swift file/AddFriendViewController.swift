//
//  AddFriendViewController.swift
//  CoreDataFriends
//
//  Created by gaomanli on 24/03/2020.
//  Copyright © 2020 gaomanli. All rights reserved.
//

import UIKit
import CoreData

class AddFriendViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    // coredata objects and functions
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       var friendManagedObject : Friends! = nil
        var entity:NSEntityDescription! = nil
    
    // save and update functions
    func update(){
        
        // collect from textfields the data to friendManagedObject
        friendManagedObject.name = nameTextField.text
        friendManagedObject.phone = phoneTextField.text
        friendManagedObject.address = addressTextField.text
        friendManagedObject.url = urlTextField.text
        friendManagedObject.image = nameTextField.text
        
        // save context
        do{ try context.save()}
        catch{print("context cannot save\n")}
        saveImage(imageName: friendManagedObject.image!)
    }
    
    func save() {
        // create a new friendManagedObject
        entity = NSEntityDescription.entity(forEntityName: "Friends", in: context)
        friendManagedObject = Friends(entity: entity, insertInto: context)
        //collect the data from textfields to friendManagedObject
        friendManagedObject.name = nameTextField.text
        friendManagedObject.phone = phoneTextField.text
        friendManagedObject.address = addressTextField.text
        friendManagedObject.url = urlTextField.text
        friendManagedObject.image = nameTextField.text
        
        // save context
        do{ try context.save()}
        catch{print("context cannot save\n")}
        saveImage(imageName: friendManagedObject.image!)
    }
    
    
       
       
    //outlets and 1 action
    
    
    
    @IBOutlet weak var pickedImage: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    //@IBOutlet weak var imageNameTextField: UITextField!
    
    //@IBOutlet weak var validLable: UILabel!
    
    @IBOutlet var textFiels: [UITextField]!
    @IBOutlet var imageField: [UIImageView]!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func addUpdateAction(_ sender: Any) {
        
        // either save or update
        if friendManagedObject != nil {
            update()
        }else{
            save()
        };
       
        // force moving to the table
        navigationController?.popViewController(animated:true)
        
        
    }
    @IBAction func pickedUpAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            //imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker,animated: true,completion: nil)
        }
    }
    
    let imagePicker = UIImagePickerController()
   
    
    
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]

) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.pickedImage.image = pickedImage
        
        print("Image name is", pickedImage?.description as Any)
        dismiss(animated: true, completion: nil)
    }
    
    /*func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        var tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePreview.image  = tempImage

        self.pickedImage.image = pickedImage
        print("Image name is", pickedImage?.description as Any)
        dismiss(animated: true, completion: nil)

    }*/
    
    
    
    func  imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
   
    }
    
    func saveImage(imageName:String){
        //create an instance of the FileManager
        let fileManager = FileManager.default
        //get the image path
        let imagePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        // append name to path
        let path = imagePath.appendingPathComponent(imageName)
        //get the image we took with camera
        //let image = pickedImage.image!
        //get the PNG data for this image
        let data = pickedImage.image!.pngData()
        //store it in the document directory
        fileManager.createFile(atPath: path as String, contents: data, attributes: nil)
        
    }
    func getImage(imageName:String) {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath) {
            pickedImage.image = UIImage(contentsOfFile: imagePath)
        }else{
            print("Panic! No Image!")
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View
        setupView()

        // Register View Controller as Observer
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        
        
        // Do any additional setup after loading the view.
        // populate the fields if update
        if friendManagedObject != nil{
            nameTextField.text = friendManagedObject.name
            phoneTextField.text = friendManagedObject.phone
            addressTextField.text = friendManagedObject.address
            urlTextField.text = friendManagedObject.url
            nameTextField.text = friendManagedObject.image
            
            getImage(imageName:friendManagedObject.image!)
            
            if friendManagedObject.image != nil{
                getImage(imageName:friendManagedObject.image!)
                
            }
            
        }
        imagePicker.delegate = self
    }
     
    
    // MARK: - View Methods

    fileprivate func setupView() {
        // Configure Save Button
        saveButton.isEnabled = false

        // Configure Validation Label
        //validLable.isHidden = true
    }

    // MARK: - Notification Handling

    @objc private func textDidChange(_ notification: Notification) {
        var formIsValid = true

        for textField in textFiels {
            // Validate Text Field
            let (valid, _) = validate(textField)

            guard valid else {
                formIsValid = false
                break
            }
        }
        
        
        // Update Save Button
        saveButton.isEnabled = formIsValid
    }

    // MARK: - Helper Methods

    fileprivate func validate(_ textField: UITextField) -> (Bool, String?) {
        guard let text = textField.text else {
            return (false, nil)
        }
    
/*
        if textField == phoneTextField {
            return (text.count >= 11, "Your phone number is too short.")
        }

        return (text.count > 0, "This field cannot be empty.")
*/
        return(text.count > 0,"This field cannot be empty.")
    }
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddFriendViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            phoneTextField.becomeFirstResponder()
        case phoneTextField:
            addressTextField.becomeFirstResponder()
         /*   let (valid, message) = validate(textField)

            if valid {
                addressTextField.becomeFirstResponder()
            }

            // Update Password Validation Label
            self.validLable.text = message

            // Show/Hide Password Validation Label
            UIView.animate(withDuration: 0.25, animations: {
                self.validLable.isHidden = valid
            })*/
        case addressTextField:
            urlTextField.becomeFirstResponder()
        default:
            urlTextField.resignFirstResponder()
        }

        return true

    }
    
    
}
