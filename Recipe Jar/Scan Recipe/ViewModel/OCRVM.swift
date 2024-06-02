//A class responsible for recognizing texts from images captured from the camera view controller and sending the recognized text
//to the backend server
import Foundation
import Vision
import VisionKit

final class OCRVM {
    let cameraScan: VNDocumentCameraScan
    
    init(cameraScan: VNDocumentCameraScan) {
        self.cameraScan = cameraScan
    }
    
    //A queue for processing text recognition requests
    private let queue = DispatchQueue(label: "scan-codes", qos: .default, attributes: [], autoreleaseFrequency: .workItem)
    
    //A function that applies text recognition on the scanned images
    func detectRecipeText(withCompletionHandler completionHandler: @escaping ([String]) -> Void) {
        queue.async {
            var images: [CGImage] = []
            //extract CGImages from each scanned page using a for loop
            for pageIndex in 0..<self.cameraScan.pageCount {
                if let cgImage = self.cameraScan.imageOfPage(at: pageIndex).cgImage {
                    images.append(cgImage)
                }
            }
            var imagesAndRequests: [(image: CGImage, request: VNRecognizeTextRequest)] = []
            
            //A tuple of (image,request) each image with its request to apply parallel image processing
            for image in images {
                let request = VNRecognizeTextRequest()
                imagesAndRequests.append((image: image, request: request))
            }
            
            var textPerPage: [String] = []
            
            //Process each image and extract recognized text using a for loop
            for (image, request) in imagesAndRequests {
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do {
                    try handler.perform([request])
                    
                    guard let observations = request.results else { return }
                    //Extract recognized text from each image
                    for observation in observations {
                        if let recognizedText = observation.topCandidates(1).first?.string {
                            textPerPage.append(recognizedText)
                        }
                    }
                } 
                catch {
                    textPerPage.append("")
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(textPerPage)
            }
        }
    }
}











