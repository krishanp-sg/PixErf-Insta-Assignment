
//
//  MyPicturesVCViewController.swift
//  PixErfTest-Instagram
//
//  Created by Krishantha Sunil Premaretna on 10/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData
import MBProgressHUD


class MyPicturesVCViewController: UIViewController {
    
    @IBOutlet weak var userImageCollectionView: UICollectionView!
    
    var blockOperations: [NSBlockOperation] = []
    var fetchedResultsController: NSFetchedResultsController? = NSFetchedResultsController()
    var refreshControl = UIRefreshControl()
    var isRefreshing:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndictor()
        setupRefreshController()
        
        
        let userImageDA = UserImageDataAccess()
        if(!userImageDA.UserImageExists()){
            
            self.DownloadUserInstaMedia()
            return
        }
        
         self.initializeFetchedResultsController()
        
        
    }
    
    
    func DownloadUserInstaMedia() {
        
        let urlTo:String = InstagramConstants.MEDIA_API + NSUserDefaults.standardUserDefaults().stringForKey("ClientToken")!
        
        let downloadUserMedia = DownloadInstagramMedia();
        downloadUserMedia.downloadUserMedias(urlTo,completion: {_ in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.initializeFetchedResultsController()
//                if(self.isRefreshing){
//                    self.refreshControl.endRefreshing()
//                    self.isRefreshing = false;
//                }
                
            })
        })
        
    }
    
    // MARK: Refresh Controller
    func setupRefreshController() {
        
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(MyPicturesVCViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.userImageCollectionView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        
        setupActivityIndictor()
        self.isRefreshing = true;
        // Remove all the Entries from the CoreData
        let userImageDA = UserImageDataAccess()
        userImageDA.deleteAllUserImage()
        self.DownloadUserInstaMedia()
        self.refreshControl.endRefreshing()
    }
    
    // MARK: Setup ActivityIndicatorView
    func setupActivityIndictor(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Fetching Images"
    }
    
    
    @IBAction func LogoutButtonClicked(sender: AnyObject) {
        
        // Set the Root View Controller to Login View Controller
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.setupLoginViewController()
        
        // Clear Client Token
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ClientToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // Remove all the Entries from the CoreData
        let userImageDA = UserImageDataAccess()
        userImageDA.deleteAllUserImage()
        
    }
    
    deinit {
        // Cancel all block operations when VC deallocates
        for operation: NSBlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepCapacity: false)
    }
    
    
}


// MARK: NSFetchedResultsController and Delegate

extension MyPicturesVCViewController: NSFetchedResultsControllerDelegate {
    
    func initializeFetchedResultsController() {
        
        
        self.fetchedResultsController = nil;
        
        let userImageDA = UserImageDataAccess()
        self.fetchedResultsController = userImageDA.getFetchedResultsControllerForUserImage()
        
        
        do {
            try self.fetchedResultsController?.performFetch()
            self.fetchedResultsController?.delegate = self;
            self.userImageCollectionView.reloadData()
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            
        } catch let error as NSError {
            let alertController = AlertController()
            alertController.showFailureAlertAndExitApp("Unable to perform fetch: \(error.localizedDescription)", callingVC: self)
        }
        
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        if type == NSFetchedResultsChangeType.Insert {
            
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    
                    self?.userImageCollectionView!.insertItemsAtIndexPaths([newIndexPath!])
                    
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Update {

            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    
                    self?.userImageCollectionView!.reloadItemsAtIndexPaths([indexPath!])
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Move {
            
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    
                    self?.userImageCollectionView!.moveItemAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Delete {
            
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    
                    self?.userImageCollectionView!.deleteItemsAtIndexPaths([indexPath!])
                    })
            )
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        if type == NSFetchedResultsChangeType.Insert {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    
                    self?.userImageCollectionView!.insertSections(NSIndexSet(index: sectionIndex))
                    
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Update {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    self?.userImageCollectionView!.reloadSections(NSIndexSet(index: sectionIndex))
                    })
            )
        }
        else if type == NSFetchedResultsChangeType.Delete {
            blockOperations.append(
                NSBlockOperation(block: { [weak self] in
                    self?.userImageCollectionView!.deleteSections(NSIndexSet(index: sectionIndex))
                    
                    })
            )
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.userImageCollectionView!.performBatchUpdates({ () -> Void in
            for operation: NSBlockOperation in self.blockOperations {
                operation.start()
            }
            }, completion: { (finished) -> Void in
                self.blockOperations.removeAll(keepCapacity: false)
        })
    }
    
}

// MARK: Collection view delegate

extension MyPicturesVCViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (fetchedResultsController?.objectAtIndexPath(indexPath) as? UserImage) != nil {
            let collectioViewCell  = collectionView.dequeueReusableCellWithReuseIdentifier("imageCell", forIndexPath: indexPath) as! CollectionViewCell
            let userImage = fetchedResultsController?.objectAtIndexPath(indexPath) as? UserImage
            collectioViewCell.setupData((userImage?.thumbnail)!)
            return collectioViewCell
        }
        
        return UICollectionViewCell()
    }
}



