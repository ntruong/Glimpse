//
//  Document.swift
//  Glimpse
//
//  Copyright © 2019 ntruong. All rights reserved.
//

import Cocoa
import Quartz

class Document : NSObject {
    let delegate: AppDelegate
    private let url: URL
    private let pdfView: PDFView
    private let window: Window
    private let windowController: NSWindowController
    private var observer: Observer?

    init(delegate: AppDelegate, file url: URL) {
        self.delegate = delegate

        self.url = url

        self.pdfView = PDFView()
        self.pdfView.autoScales = true
        self.pdfView.displaysPageBreaks = false
        self.pdfView.backgroundColor = .clear

        self.window = Window()
        self.window.contentView = self.pdfView

        self.windowController = NSWindowController(window: self.window)

        super.init()
        self.window.document = self

        guard let _ = PDFDocument(url: self.url) else { return }
        self.observer = Observer(file: url)
        self.observer?.start { self.load() }
        self.load()
        self.window.center()
        self.window.makeKeyAndOrderFront(self)
    }


    func load() {
        DispatchQueue.main.async {
            guard let pdf = PDFDocument(url: self.url) else { return }
            let finish = { () -> Void in self.pdfView.document = pdf }
            guard let dest = self.pdfView.currentDestination else { return finish() }
            guard let prevPage = dest.page else { return finish() }
            guard let prevNum = self.pdfView.document?.index(for: prevPage) else { return finish() }
            finish()
            let num = pdf.pageCount > prevNum ? prevNum : pdf.pageCount - 1
            guard let nextPage = pdf.page(at: num) else { return }
            self.pdfView.go(to: PDFDestination(page: nextPage, at: dest.point))
        }
    }

    func close() { self.observer?.stop() }
}
