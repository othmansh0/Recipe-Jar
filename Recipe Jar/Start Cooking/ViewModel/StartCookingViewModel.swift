import AVFoundation
import Foundation
import Speech
import SwiftUI

final class StartCookingViewModel: BaseVM{
    
    //MARK: Speech Recognetion Properties
    var audioEngine = AVAudioEngine()
    let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    var request = SFSpeechAudioBufferRecognitionRequest()//object to perform speech recognition on live audio on specified buffer
    @State var task : SFSpeechRecognitionTask?//To control recognizer state (cancel it or)
    var trueFormat: AVAudioFormat!
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var commands = "Instruction:"
    @State private var btnTitle = ""
    @State private var imageName = ""
    
    @Published var currentPage = 0
    @Published var isSpeaking = false


    @Published var showYoutubeModalView = false
    @Published var isYoutubeDisabled = false
    
    @Published var hasError = false //tells our view if an error has occured
    @Published var localError:String? // holds the error
    
    
    
    
    @State var synthesizer = AVSpeechSynthesizer()
    @Published var isReading = false
    @Published var isReadingOn = false
    //specify what we want to say
    @Published var utterance = AVSpeechUtterance(string: "step ")
    
    @Published var selectedRecipe: Recipe
    private var networkService: Networkable

    init(networkService: Networkable = NetworkService(),recipe: Recipe){
        self.selectedRecipe = recipe
        self.networkService = networkService
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [ .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }
    
    func backStep(){
        if currentPage > 0 {
            currentPage -= 1
            checkReading()
        }
    }
    
    //Used in all methods(Swipping/Voice Commands/Buttons) that navigates to the next recipe's step
    func nextStep(){
        guard let steps = selectedRecipe.steps else { return }
        if currentPage < steps.count - 1 {
            currentPage += 1
            checkReading()
        }
    }
    
    func setError(message: String) {
        hasError = true
        localError = message
    }
    
}



//MARK: Voice Commands
extension StartCookingViewModel {
    
    //A function to request user's permission to speech recongizer via phone microphone
    private func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authState in
            OperationQueue.main.addOperation{
                if authState == .authorized {
                } else if authState == .denied {
                    self?.setError(message: "user denied mic persmission")
                } else if authState == .notDetermined {
                    self?.setError(message: "your phone has no speech recognizer")
                } else if authState == .restricted {
                    self?.setError(message: "your phone has been restricted from speech recognizer")
                }
            }
        }
    }
    
    
    
    private func startSpeechRecognization(){
        //Takes audio input by audio engine creating a singleton when accessing the variable
        let node = audioEngine.inputNode
        //check if there exist an input node that's taking audio to remove it
        node.removeTap(onBus: 0)
        //Retrieves the output format for the bus(signal path) specified
        let recordingFormat = node.outputFormat(forBus: 0)
        if recordingFormat.sampleRate == 0 {
            trueFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1)
        } else {
            trueFormat = recordingFormat
        }
        //To start recording, monitoring, and observing the output of audio input node
        node.installTap(onBus: 0, bufferSize: 1024, format: trueFormat) { buffer, audioTime in
            //specify the buffer for the live audio
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            setError(message: "error preparing the audio")
        }
        //check Speech recognition availability in user's location/local
        guard let myRecgonition = SFSpeechRecognizer() else {
            setError(message: "Recgonization is not allowed in your location")
            return
        }
        //check Speech recognition availability if it is currently in use or free
        if !myRecgonition.isAvailable {
            setError(message: "Speech Recognizer is not available please try again later")
        }
        //resets the recognitionRequest to avoid "cannot be re-use" error
        request = SFSpeechAudioBufferRecognitionRequest()//recreates recognitionRequest object.
        task = (speechReconizer?.recognitionTask(with: request) { [weak self](response,error) in
            guard let response = response else {
                if error != nil {
                    self?.setError(message: error.debugDescription)
                }
                else {
                    self?.setError(message: "something went wrong with giving a respone")
                }
                return
            }
            //get transcription with the highest confidence level
            let message = response.bestTranscription.formattedString
            self?.commands = message
            var lastWord: String = ""
            for segment in response.bestTranscription.segments {
                if self?.isSpeaking == false {
                    return
                }
                //Get Last word from the user's Speech
                let indexTo = message.index(message.startIndex, offsetBy: segment.substringRange.location)
                lastWord = String(message[indexTo...])
                //check if last word is next/back/repeat
                if lastWord.lowercased() == "next" {
                    self?.nextStep()
                } else if lastWord.lowercased() == "back" {
                    self?.backStep()
                } else if lastWord.lowercased() == "repeat" {
                    self?.checkReading()
                }
            }
        })!
    }
    
    
    private func cancelSpeechRecognization() {
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        task?.finish()
        task?.cancel()
        task = nil
        //check if there exist an input node that's taking audio to remove it
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
    
    func checkSpeaking(){
        if isSpeaking {
            requestPermission()
            startSpeechRecognization()
        }
        else {
            cancelSpeechRecognization()
        }
    }
}


extension StartCookingViewModel {
    
    private func startReading(step:Step) {
        isReadingOn = true
        isReading = true
        //utterance is the step text to be spoken
        utterance = AVSpeechUtterance(string: "Step \(step.orderNumber) \(step.description)")
        //synthesizer handles the playback of generated audio and provides control over speech (starting/pausing/stoppings)
        synthesizer.speak(utterance)
    }
    private func stopReading() {
        isReadingOn = false
        isReading = false
        synthesizer.stopSpeaking(at: .immediate)
    }
    
     func toggleIsReadingOn(){
        isReadingOn.toggle()
    }
    
    //Decides wheather to read or to stop reading
    func checkReading() {
        if isReading {
            stopReading()
            guard let steps = selectedRecipe.steps else { return }
            startReading(step: steps[currentPage])
        }
        else {
            stopReading()
        }
    }
}

extension StartCookingViewModel {
     func getSteps(recipeID: Int? = nil, skipLoading: Bool = false) async -> [Step] {
            if let result: [Step] = loadJson(filename: "MockRecipeSteps") {
                DispatchQueue.main.async {
                    self.selectedRecipe.steps = result
                }
                return result
            }
          return []
        }
}



