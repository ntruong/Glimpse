//
//  Observer.swift
//  Glimpse
//
//  Copyright © 2019 ntruong. All rights reserved.
//

import Cocoa
import Quartz

class Observer {
    private let file: URL
    private let handler: () -> Void
    private var source: DispatchSourceFileSystemObject?

    init(file: URL, handler: @escaping () -> Void) {
        self.file = file
        self.handler = handler
    }

    func start() {
        let fd = open(self.file.path, O_EVTONLY)
        if fd > 0 {
            self.dispatch(fd: fd, closure: {
                if FileManager.default.fileExists(atPath: self.file.path) {
                    self.handler()
                }
                else { self.monitor() }
            })
        }
        else { self.monitor() }
    }

    func stop() {
        self.source?.cancel()
        self.source = nil
    }

    private func dispatch(fd: Int32, closure: @escaping () -> Void) {
        self.stop()
        self.source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: [.write, .delete]
        )
        self.source?.setEventHandler(handler: closure)
        self.source?.setCancelHandler { close(fd) }
        self.source?.resume()
    }

    private func monitor() {
        let fd = open(self.file.deletingLastPathComponent().path, O_RDONLY)
        if fd > 0 {
            self.dispatch(fd: fd, closure: {
                if FileManager.default.fileExists(atPath: self.file.path) {
                    self.start()
                }
            })
        }
    }
}
