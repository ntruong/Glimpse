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

        let menuEdit = NSMenu(title: "Edit")
        menuEdit.addItem(withTitle: "Copy", action: #selector(copyText),
            keyEquivalent: "c")
        let menuEditItem = NSMenuItem()
        menuEditItem.submenu = menuEdit
        menu.addItem(menuEditItem)

        NSApp.mainMenu = menu

        documents = []
    }

    func applicationWillTerminate(_ aNotification: Notification) { }

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        for (_, file) in filenames.enumerated() {
            self.openFile(file: URL(fileURLWithPath: file))
        }
    }

    func application(_sender: NSApplication, openFile file: String) -> Bool {
        self.openFile(file: URL(fileURLWithPath: file))
        return true
    }

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
        if let (window, document) = loadDocument() {
            document.close()
            window.close()
            self.documents?.remove(document)
        }
    }

    @objc
    func copyText() {
        if let (_, document) = loadDocument() { document.copyText() }
    }

    func loadDocument() -> (Window, Document)? {
        guard let window = NSApp.keyWindow as? Window else { return nil }
        guard let document = window.document else {
            window.close()
            return nil
        }
        return (window, document)
    }

    func openFile(file url: URL) {
        let document = Document(file: url)
        self.documents?.insert(document)
    }
}
