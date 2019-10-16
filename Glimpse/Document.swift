//
//  Document.swift
//  Glimpse
//
//  Copyright © 2019 ntruong. All rights reserved.
//

import Cocoa
import Quartz

class Document : NSObject {
    private let url: URL
    private let pdfView: PDFView
    private let windowController: NSWindowController
    private var observer: Observer?

    init(file url: URL) {
        self.url = url

        self.pdfView = PDFView()
        self.pdfView.autoScales = true
        self.pdfView.backgroundColor = .windowBackgroundColor

        let window = Window()

        self.windowController = NSWindowController(window: window)

        super.init()

        window.document = self
        window.contentView = self.pdfView

        self.observer = Observer(file: url, handler: self.load)
        self.observer?.start()
        guard let _ = PDFDocument(url: self.url) else { return }
        self.load()
        window.center()
        window.makeKeyAndOrderFront(self)
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

    func close() {
        self.observer?.stop()
        self.windowController.window?.close()
    }
}
