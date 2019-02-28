//
//  AppDelegate.swift
//  Glimpse
//
//  Copyright © 2019 ntruong. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var documents: Set<Document>?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let menu = NSMenu()

        let menuMain = NSMenu()
        menuMain.addItem(withTitle: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
        let menuMainItem = NSMenuItem()
        menuMainItem.submenu = menuMain
        menu.addItem(menuMainItem)

        let menuFile = NSMenu(title: "File")
        menuFile.addItem(withTitle: "Open", action: #selector(promptForFiles), keyEquivalent: "o")
        menuFile.addItem(withTitle: "Close", action: #selector(closeWindow), keyEquivalent: "w")
        let menuFileItem = NSMenuItem()
        menuFileItem.submenu = menuFile
        menu.addItem(menuFileItem)

        NSApp.mainMenu = menu

        documents = []
    }

    func applicationWillTerminate(_ aNotification: Notification) { }

    @objc
    func promptForFiles() {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = true
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["pdf"]

        if openPanel.runModal() == .OK {
            for (_, file) in openPanel.urls.enumerated() {
                openFile(file: file)
            }
        }
    }

    @objc
    func closeWindow() {
        guard let window = NSApp.keyWindow as? Window else { return }
        guard let document = window.document else { return window.close() }
        document.delegate.documents?.remove(document)
        document.close()
        window.close()
    }

    func openFile(file url: URL) {
        let document = Document(delegate: self, file: url)
        self.documents?.insert(document)
    }
}
