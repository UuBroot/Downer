//
//  saveFileDialog.swift
//  Downer
//
//  Created by Timon Rosenbichler on 04.11.24.
//
import Cocoa

func saveFileFromBundle(type: String) throws -> URL {
    let openPanel = NSOpenPanel()
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = true
    openPanel.allowsMultipleSelection = false
    
    let result = openPanel.runModal()
    
    switch result {
    case .OK:
        guard let url = openPanel.url else { return URL(filePath: "")!}
        return url
    case .cancel:
        print("Operation cancelled")
        return URL(filePath: "")!
    default:
        print("Unexpected result")
        throw CocoaError(.fileReadNoSuchFile)
    }
}
