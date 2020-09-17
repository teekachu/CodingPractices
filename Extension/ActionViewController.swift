//
//  ActionViewController.swift
//  Extension
//
//  Created by Tee Becker on 9/15/20.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // when extension first created, extensionContext lets us control how it interacts with parent app. find the first inputitem and type cast as NSExtensionItem
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem{
            // our input item contains an array of attachments, pull the first one
            if let itemProvider = inputItem.attachments?.first{
                //to adk the item provider to actually provide/load the item. Closure means the method will carry on while item provider load and send us data.
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String){
                    [weak self] (dict, error) in
                    // do stuff once item successfully pulled out
                    
                    guard let itemDictionary = dict as? NSDictionary else{return}
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else{return}
                    
                    //                    print(javaScriptValues)
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        //setting the view controller's title on the main queue to be the title of page
                        self?.title = self?.pageTitle
                    }
                    
                }
            }
        }
        
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        //        var imageFound = false
        //        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
        //            for provider in item.attachments! {
        //                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
        //                    // This is an image. We'll load it, then place it in our image view.
        //                    weak var weakImageView = self.imageView
        //                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (imageURL, error) in
        //                        OperationQueue.main.addOperation {
        //                            if let strongImageView = weakImageView {
        //                                if let imageURL = imageURL as? URL {
        //                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
        //                                }
        //                            }
        //                        }
        //                    })
        //
        //                    imageFound = true
        //                    break
        //                }
        //            }
        //
        //            if (imageFound) {
        //                // We only handle one image, so stop looking for more.
        //                break
        //            }
        //        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }
    
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        //        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
        
        //modify it to pass back the text user entered into our textview to finalize() method in Action.js
        
        //1. create new NSExtensionItem object to host our items.
        let item = NSExtensionItem()
        //2. create dictionary containing the key customJavascript and values of script
        let argument: NSDictionary = ["customJavaScript": script.text]
        //3. put the dictionary in another dictionary with key NSExtensionJavascriptFinalizeArgumentKey
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        //4. wrap inside NSItemProvider, with type identifier KUTTypePropertyList
        let customJavascript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        //5. place the NSItemProvider into our NSExtensionItem as attachments.
        item.attachments = [customJavascript]
        //6. call completeRequest
        extensionContext?.completeRequest(returningItems: [item])
        
    }
    
}

