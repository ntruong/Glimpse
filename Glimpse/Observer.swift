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
    private var source: DispatchSourceFileSystemObject?

    init(file: URL) { self.file = file }

    func start(handler: @escaping () -> Void) {
        let fd = open(self.file.path, O_EVTONLY)
        if fd > 0 {
            self.source = DispatchSource.makeFileSystemObjectSource(
                fileDescriptor: fd,
                eventMask: [.write],
                queue: DispatchQueue.main
            )
            self.source?.setEventHandler(handler: handler)
            self.source?.setCancelHandler { close(fd) }
            self.source?.resume()
        }
    }

    func stop() { self.source?.cancel() }
}
