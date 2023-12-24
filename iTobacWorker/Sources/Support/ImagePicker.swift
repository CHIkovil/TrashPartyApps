//
//  UserImagePicker.swift
//  iTobacWorker
//
//  Created by Nikolas on 08.12.2021.
//

import Foundation
import UIKit

private enum ImagePickerString: String {
    case mediaTypes = "public.image"
    case cameraTitle = "Camera"
    case photoLibraryTitle =  "Photo library"
    case cancelTitle = "Cancel"
}

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?)
}

class ImagePicker: NSObject {
    
    //MARK: init
    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = [ImagePickerString.mediaTypes.rawValue]
    }
    
    //MARK: present
    func present() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: ImagePickerString.cameraTitle.rawValue) {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title:ImagePickerString.photoLibraryTitle.rawValue) {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: ImagePickerString.cancelTitle.rawValue, style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    
    //MARK: PRIVATE
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    //MARK: SUPPORT FUNC
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
}

//MARK: DELEGATE EXTENSION

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.delegate?.didSelect(image: image)
            picker.dismiss(animated: true)
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate {
}
