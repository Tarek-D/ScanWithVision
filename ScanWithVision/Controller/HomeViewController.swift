//
//  HomeViewController.swift
//  ScanWithVision
//
//  Created by Tarek Noubli on 07/04/2022.
//

import UIKit
import VisionKit

final class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    private var documents: [Document] = .init()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var documentsTableView: UITableView!
    @IBOutlet weak var scanButton: UIBarButtonItem!
    
    @IBAction func scanButtonTouched(_ sender: Any) {
        loadScannerViewController()
    }
    
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfSupportedDevice()
    }
    
    // MARK: Methods

    private func checkIfSupportedDevice() {
        scanButton.isEnabled = VNDocumentCameraViewController.isSupported ? true : false
    }
    
    private func loadScannerViewController() {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
    }
}

// MARK: - Extension VNDocumentCameraViewControllerDelegate

extension HomeViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith
                                      scan: VNDocumentCameraScan) {
        for index in 0 ..< scan.pageCount {
            let image = scan.imageOfPage(at: index)
            let document = Document(title: Date().formatted(), image: image.jpegData(compressionQuality: 1)!)
            documents.append(document)
            documentsTableView.reloadData()
        }
    }
}

// MARK: Extension UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell",
                                                       for: indexPath) as? DocumentTableViewCell else {
            fatalError("Unable to dequeue DocumentCell")
        }
        return cell
    }
}
