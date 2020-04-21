//
//  ViewController.swift
//  Data save using URL
//
//  Created by AshutoshD on 14/04/20.
//  Copyright © 2020 ravindraB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtURL: UITextField!
    var imageArray = [UIImage]()
    var imgNameArray =  [String]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
//        createDirectory()
        
    getImageFromDocumentDirectory()
        print(imgNameArray)
    }


    @IBAction func BtnSaveTapped(_ sender: UIButton) {
   
//            setImage(from: "https://image.blockbusterbd.net/00416_main_image_04072019225805.png")
//          setImage(from: "https://tineye.com/images/widgets/mona.jpg")
        downloadAndSaveImageFile("https://homepages.cae.wisc.edu/~ece533/images/cameraman.tif");
//        downloadAndSaveImageFile("https://tineye.com/images/widgets/mona.jpg");
        downloadAndSaveAudioFile("https://file-examples.com/wp-content/uploads/2017/11/file_example_WAV_2MG.wav")
        downloadAndSaveVideoFile("http://mirrors.standaloneinstaller.com/video-sample/P6090053.3gp")
        
    }
    
    
//    func setImage(from url: String) {
//        guard let imageURL = URL(string: url) else { return }
//        // just not to cause a deadlock in UI!
//        DispatchQueue.global().async {
//            guard let imageData = try? Data(contentsOf: imageURL) else { return }
//
//            let image = UIImage(data: imageData)
//            DispatchQueue.main.async {
//                self.imgView.image = image
//                self.saveImageToDocumentDirectory(image: image!)
//            }
//        }
//    }
    
//
//    func saveImageToDocumentDirectory(image : UIImage) {
//        let fileManager = FileManager.default
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(Date()).png")
//        let imageData = image.jpegData(compressionQuality: 0.5)
//        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//        let directoryPth = getDirectoryPath()
//        print("directotyPath \(directoryPth)")
//        //        arrImages.append(getImage(imageName: "Screen.png"))
//        //        print(arrImages)
//    }
    
    
    
    // MARK:- Save Image file
    func downloadAndSaveImageFile(_ imageFile: String) {
        //Create directory if not present
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths.first! as NSString
        let imageDirPathString = documentDirectory.appendingPathComponent("Images")
        
        do {
            try FileManager.default.createDirectory(atPath: imageDirPathString, withIntermediateDirectories: true, attributes:nil)
            print("directory created at \(imageDirPathString)")
        } catch let error as NSError {
            print("error while creating dir : \(error.localizedDescription)");
        }
        
        if let imageUrl = URL(string: imageFile) {
            // create your document folder url
            let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
            let documentsFolderUrl = documentsUrl.appendingPathComponent("Images")
            // your destination file url
            var destinationUrl = documentsFolderUrl.appendingPathComponent(imageUrl.lastPathComponent)
            var imgName = imageUrl
            imgName.deletePathExtension()
            imgName.appendPathExtension("png")
            let newValue = imgName.lastPathComponent
            print(newValue)
            if !imgNameArray.contains(newValue) {
                imgNameArray.append(newValue)
                defaults.set(imgNameArray, forKey: "imgNames")
            }
            print(imgNameArray)
            destinationUrl.deletePathExtension()
            destinationUrl.appendPathExtension("png")
            print(destinationUrl)
            
//            let imageNames = defaults.value(forKey: "imgNames")
            let imageNames = defaults.object(forKey: "imgNames") as? [String] ?? [String]()
            print(imageNames)
            
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    
                    if let myImageDataFromUrl = try? Data(contentsOf: imageUrl){
                        let image = UIImage(data: myImageDataFromUrl)
                        let imageData = image!.jpegData(compressionQuality: 0.5)
                        
                        
                        
                        // after downloading your data you need to save it to your destination url
                        if (try? imageData!.write(to: destinationUrl, options: [.atomic])) != nil {
                            print("image file saved")
                            //        completion(destinationUrl.absoluteString)
                        } else {
                            print("error saving file")
                            //       completion("")
                        }
                    }
                })
            }
        }
    }
    
    
    
   // MARK:- Save audio file
    func downloadAndSaveAudioFile(_ audioFile: String) {
        //Create directory if not present
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths.first! as NSString
        let soundDirPathString = documentDirectory.appendingPathComponent("Sounds")
        
        do {
            try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
            print("directory created at \(soundDirPathString)")
        } catch let error as NSError {
            print("error while creating dir : \(error.localizedDescription)");
        }
        
        if let audioUrl = URL(string: audioFile) {
            // create your document folder url
            let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
            let documentsFolderUrl = documentsUrl.appendingPathComponent("Sounds")
            // your destination file url
            let destinationUrl = documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
            
            print(destinationUrl)
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
                        // after downloading your data you need to save it to your destination url
                        
                        if (try? myAudioDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                            print("Audio file saved")
                    //        completion(destinationUrl.absoluteString)
                        } else {
                            print("error saving file")
                     //       completion("")
                        }
                    }
                })
            }
        }
    }
    
    
     // MARK:- Save video file
    func downloadAndSaveVideoFile(_ videoFile: String) {
        
        //Create directory if not present
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths.first! as NSString
        let soundDirPathString = documentDirectory.appendingPathComponent("Videos")
        
        do {
            try FileManager.default.createDirectory(atPath: soundDirPathString, withIntermediateDirectories: true, attributes:nil)
            print("directory created at \(soundDirPathString)")
        } catch let error as NSError {
            print("error while creating dir : \(error.localizedDescription)");
        }
        
        if let videoUrl = URL(string: videoFile) {
            // create your document folder url
            let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
            let documentsFolderUrl = documentsUrl.appendingPathComponent("Videos")
            // your destination file url
            var destinationUrl = documentsFolderUrl.appendingPathComponent(videoUrl.lastPathComponent)
          
            
            print(destinationUrl)
            // check if it exists before downloading it
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async(execute: {
                    if let myVideoDataFromUrl = try? Data(contentsOf: videoUrl){
                        // after downloading your data you need to save it to your destination url
                        if (try? myVideoDataFromUrl.write(to: destinationUrl, options: [.atomic])) != nil {
                            print("Video file saved")
                            //        completion(destinationUrl.absoluteString)
                        } else {
                            print("error saving file")
                            //       completion("")
                        }
                    }
                })
            }
        }
    }
    
    
    
    //MARK:- get Directory
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //  MARK:- Creatng Directory
    func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("images")
        if !fileManager.fileExists(atPath: paths){
            do {
                try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create document directory")
            }
        }else{
            print("Already directory created.")
        }
    }
    
    
    // MARK:- Save Image
//    func saveImageToDocumentDirectory(imgString : String) {
//        let fileManager = FileManager.default
//        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgString)
//        let image = UIImage(named: imgString)
//        let imageData = image?.jpegData(compressionQuality: 0.5)
//        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
//        let directoryPth = getDirectoryPath()
//        print("directotyPath \(directoryPth)")
////        arrImages.append(getImage(imageName: "Screen.png"))
////        print(arrImages)
//    }
    
    // MARK:- Get Data
    func getImage(){
//        let fileManager = FileManager.default
        // Here using getDirectoryPath method to get the Directory path
//        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(imageName)
        
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = paths.first! as NSString
        let imageDirPathString = documentDirectory.appendingPathComponent("Images")
        
        
        
        let documentsUrl =  FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first! as URL
        let documentsFolderUrl = documentsUrl.appendingPathComponent("Images")
        
         let path = documentsFolderUrl.absoluteString
        
 
        if fileManager.fileExists(atPath: path){
        //    return arrImages
        }else{
            print("No Image available")
         //   return arrImages // Return placeholder image here
        }
    }

    
    func getImageFromDocumentDirectory() {
        let fileManager = FileManager.default
        for i in 0..<5 {
            let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("cameraman.png")
            let urlString: String = imagePath!.absoluteString
            if fileManager.fileExists(atPath: urlString) {
                let image = UIImage(contentsOfFile: urlString)
                imageArray.append(image!)
                print(imageArray)
                imgView.image = imageArray[i]
            } else {
                 print("No Image")
            }
        }
    }
   
    func getDirectoryPath() -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Images")
        let url = NSURL(string: path)
        return url!
    }
    
}




