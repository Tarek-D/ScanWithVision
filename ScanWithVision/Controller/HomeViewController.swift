//
//  HomeViewController.swift
//  ScanWithVision
//
//  Created by Tarek Noubli on 07/04/2022.
//

import UIKit
import AVFoundation
import VisionKit

final class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    private var documents: [Document] = .init()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var documentsTableView: UITableView!
    @IBOutlet weak var scanButton: UIBarButtonItem!
    
    @IBAction func scanButtonTouched(_ sender: Any) {
        checkAuthorization()
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
        present(scannerViewController, animated: true)
    }
    
    private func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.loadScannerViewController()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.loadScannerViewController()
                    }
                }
            case .denied:
            presentAlertWithRedirection()
                return
            case .restricted:
            presentAlertWithRedirection()
                return
        @unknown default:
            fatalError()
        }
    }
    private func presentAlertWithRedirection() {
        let alertController = UIAlertController(title: "Accès non authorisé",
                                                message: "L'accès a la caméra n'est pas authorisé",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "Réglages", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

// MARK: - Extension VNDocumentCameraViewControllerDelegate

extension HomeViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith
                                      scan: VNDocumentCameraScan) {
        for index in 0 ..< scan.pageCount {
            let image = scan.imageOfPage(at: index)
            let document = Document(title: Date().formatted(), image: image.jpegData(compressionQuality: 1)!)
            documents.append(document)
            documentsTableView.reloadData()
            controller.dismiss(animated: true)
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
        cell.document = documents[indexPath.row]
        return cell
    }
}
