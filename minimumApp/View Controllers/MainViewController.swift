//
//  ViewController.swift
//  minimumApp
//
//  Created by Клоун on 03.09.2022.
//

import PhotosUI
import UIKit

enum Color: String {
    case yellow
    case red
    case blue
    case green
    case gray
    
    var create: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .green:
            return UIColor.green
        case .yellow:
            return UIColor.yellow
        case .gray:
            return UIColor.gray
        }
    }
}

class MainViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterView: UIView!
    
    private let filterColors = ["Yellow", "Red", "Green", "Blue", "Gray"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let phcontroller = PHPickerViewController(configuration: config)
        phcontroller.delegate = self
        present(phcontroller, animated: true)
    }
    
    private func setupView() {
        collectionView.layer.cornerRadius = 25
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "styleCell")
        
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        
        filterView.isHidden = true
        filterView.layer.opacity = 0.2
        filterView.layer.cornerRadius = 30
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please, choose a photo", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

//MARK: - UICollectionView Delegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "styleCell",
            for: indexPath
        ) as? FilterCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let color = filterColors[indexPath.row]
        cell.configure(with: color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard image.image != nil else {
            showAlert()
            return
        }
        let selectedColor = Color(rawValue: filterColors[indexPath.row].lowercased())
        filterView.isHidden = false
        filterView.backgroundColor = selectedColor?.create
    }
}

//MARK: - PHPickerViewControllerDelegate
extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                guard let selectedImage = object as? UIImage else { return }
                DispatchQueue.main.async {
                    self?.image.image = selectedImage
                }
            }
        }
    }
}
