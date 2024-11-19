//
//  ContentView.swift
//  Downer
//
//  Created by Timon Rosenbichler on 04.11.24.
//
import Foundation
import SwiftUI
import UserNotifications

struct ContentView: View {
    @State var downloadText: String = ""
    @State private var userInput: String = ""
    @State private var savePath: URL = (FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first ?? URL(filePath: ""))
    @State var text: String = "notext"
    @State var format: String = ""
    
    @State var videoFormates:  [String] = ["mp4", "webm"]
    @State var audioFormates:  [String] = ["mp3", "wav", "flac"]
    @State var formates: [String] = []
    
    @State var isAudio: Bool = false
    
    @FocusState private var focusUserInput: Bool
        
    init() {
        formates = videoFormates //dsss to video download
    }
    
    var body: some View {
        VStack {
            
            HStack{
                TextField("Enter the Url", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        downloadMedia(url: userInput, savePath: savePath, format: Format(isAudio: isAudio, mediaFormat: format))
                    }
                    .onChange(of: userInput, initial: true) {
                        userInput = String(userInput.components(separatedBy: .whitespaces).joined())
                    }
                    .font(.title2)
                Button{
                    userInput = ""
                } label: {
                    Image(systemName: "clear")
                }.focused($focusUserInput)
                    .onAppear() {
                        focusUserInput = true
                    }
            }

            
            ZStack{
                Text(downloadText).opacity(downloadText == "Downloading ..." ? 0 : 1)
                
                ProgressView()
                      .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                      .scaleEffect(0.5, anchor: .center)
                      .opacity(downloadText == "Downloading ..." && downloadText != "" ? 1: 0)
            }
            
            HStack {
                Picker("Select Format", selection: $format) {
                    ForEach(formates, id: \.self) { format in
                        Text(format)
                    }
                }.onAppear() {
                    formates = isAudio ? audioFormates : videoFormates
                    format = videoFormates.first!

                }
                Toggle(isOn: $isAudio) {
                    Text("isAudio")
                }.onChange(of: isAudio) {
                    formates = isAudio ? audioFormates : videoFormates
                    if isAudio {
                        format = audioFormates.first!
                    }else{
                        format = videoFormates.first!
                    }
                }
            }
            
            HStack {

                Text(savePath.path.split(separator: "/").last ?? "No Path")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button{
                    do {
                        try savePath = saveFileFromBundle(type: ".mp4")
                    }catch {
                        print("err")
                    }
                } label: {
                    Image(systemName: "pencil")
                }
            }
            Button("Download"){
                if !userInput.isEmpty {
                    downloadMedia(url: userInput, savePath: savePath, format: Format(isAudio: isAudio, mediaFormat: format))
                }
            }.font(.title2)

            Divider().padding(5)
            
            HStack {
                Button("Close"){
                    NSApp.terminate(self)
                }
            }
            
        }
        .padding()

    }

    func downloadMedia(url: String, savePath: URL, format: Format){
        downloadText = "Downloading ..."
        
        let downloader = Download.download(url: url, savePath: savePath, format: format)
        print(downloader)
        
        if downloader != "" {
            downloadText = String(downloader.split(separator: ".")[0].split(separator: "]")[1])
        }else {
            downloadText = "Downloaded"
            userInput = ""
        }
    }
}

#Preview {
    ContentView()
}
