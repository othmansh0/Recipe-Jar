//A struct view that uses a Camera View controller(created in UIKit) and handles the connection between a Camera View and SwiftUI view
import VisionKit
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: ([String]?) -> Void
    private let cancelAction: () -> Void

    init(completion: @escaping ([String]?) -> Void, cancelAction: @escaping () -> Void) {
        self.completionHandler = completion
        self.cancelAction = cancelAction
    }

    //UIViewController to present a UIKit view in SwiftUI
    typealias UIViewControllerType = VNDocumentCameraViewController

    //A function that creates the UIViewController instance
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }

    //A function that updates the UIViewController instance if needed
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}

    //A Coordinator instance that handles delegate callbacks (results from UIViewController)
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler, cancelAction: cancelAction)
    }

    //A Coordinator class that handles VNDocumentCameraViewControllerDelegate callbacks (results from UIViewController)
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let completionHandler: ([String]?) -> Void
        private let cancelAction: () -> Void

        init(completion: @escaping ([String]?) -> Void, cancelAction: @escaping () -> Void) {
            self.completionHandler = completion
            self.cancelAction = cancelAction
        }

        //A function that gets called when the camera finishes capturing a scan
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            let recognizer = OCRVM(cameraScan: scan)
            recognizer.detectRecipeText(withCompletionHandler: completionHandler)
        }

        //A function that gets called when the camera view gets canceled
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
            cancelAction()
        }

        //A function that gets called whenever an error occurs in the Camera View
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            completionHandler(nil)
        }
    }
}
