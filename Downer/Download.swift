//
//  Downloader.swift
//  Downer
//
//  Created by Timon Rosenbichler on 04.11.24.
//

import Foundation
import AppKit
import SwiftUI

class Download {
    private var timer: Timer?
    
    static func download(url: String, savePath: URL, format: Format)->String{
        let path = String(Bundle.main.path(forResource: "yt-dlp_macos", ofType: "")!)
        
        let ffmpegPath = String(Bundle.main.path(forResource: "ffmpeg", ofType: "")!)
        
        let task = Process()
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        task.standardOutput = stdoutPipe
        task.standardError = stderrPipe
        
        var arguments: [String] = []
        arguments.append("-P")
        arguments.append(savePath.path)
        
        if format.isAudio {
            arguments.append("-x")
            arguments.append("--audio-format")
        }else{
            arguments.append("-f")
        }
        
        arguments.append(format.mediaFormat)
        
        arguments.append("--ffmpeg-location")
        arguments.append(ffmpegPath)
        arguments.append(url)
        
        print(arguments)
        
        task.launchPath = path
        task.arguments = arguments
        
        task.launch()
       
        task.waitUntilExit()
        
        let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

        let stderrOutput = String(data: stderrData, encoding: .utf8)

        print(stderrOutput ?? "default")
        
        print("Exit code: \(task.terminationStatus)")
        if task.terminationStatus != 0 {
            return stderrOutput ?? "error"
        }else{
            return ""
        }
    }
    
}
