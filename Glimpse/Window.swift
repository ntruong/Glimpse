//
//  Window.swift
//  Glimpse
//
//  Copyright © 2019 ntruong. All rights reserved.
//

import Cocoa

class Window : NSWindow {
    var document: Document?

    init() {
        super.init(
            contentRect: NSMakeRect(100, 100, 500, 500 * 1.2),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: true
        )
        self.titlebarAppearsTransparent = true
        self.standardWindowButton(.closeButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden = true
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = true
    }
}
