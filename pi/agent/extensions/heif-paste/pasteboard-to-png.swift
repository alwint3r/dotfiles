import AppKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

private let noImageExitCode: Int32 = 2
private let explicitImageTypes: Set<String> = [
    "public.heic",
    "public.heics",
    "public.heif",
    "public.avif",
]

private func isImageType(_ type: NSPasteboard.PasteboardType) -> Bool {
    if explicitImageTypes.contains(type.rawValue) {
        return true
    }

    return UTType(type.rawValue)?.conforms(to: .image) == true
}

private func image(from data: Data) -> NSImage? {
    if let image = NSImage(data: data) {
        return image
    }

    guard
        let source = CGImageSourceCreateWithData(data as CFData, nil),
        let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
    else {
        return nil
    }

    return NSImage(cgImage: cgImage, size: .zero)
}

private func imageFileURLs(from pasteboard: NSPasteboard) -> [URL] {
    let options: [NSPasteboard.ReadingOptionKey: Any] = [
        .urlReadingFileURLsOnly: true,
    ]

    return pasteboard.readObjects(
        forClasses: [NSURL.self],
        options: options
    ) as? [URL] ?? []
}

private func imageFromPasteboard(_ pasteboard: NSPasteboard) -> (NSImage?, Bool) {
    if let pasteboardImage = NSImage(pasteboard: pasteboard) {
        return (pasteboardImage, true)
    }

    var foundImageRepresentation = false

    for item in pasteboard.pasteboardItems ?? [] {
        for type in item.types where isImageType(type) {
            foundImageRepresentation = true
            if let data = item.data(forType: type), let decoded = image(from: data) {
                return (decoded, true)
            }
        }
    }

    for url in imageFileURLs(from: pasteboard) where url.isFileURL {
        let type = UTType(filenameExtension: url.pathExtension)
        guard type?.conforms(to: .image) == true else {
            continue
        }

        foundImageRepresentation = true
        if let decoded = NSImage(contentsOf: url) {
            return (decoded, true)
        }
    }

    return (nil, foundImageRepresentation)
}

private func pngData(from image: NSImage) -> Data? {
    var proposedRect = NSRect(origin: .zero, size: image.size)
    guard
        proposedRect.width > 0,
        proposedRect.height > 0,
        let cgImage = image.cgImage(
            forProposedRect: &proposedRect,
            context: nil,
            hints: nil
        )
    else {
        return nil
    }

    return NSBitmapImageRep(cgImage: cgImage).representation(
        using: .png,
        properties: [:]
    )
}

guard CommandLine.arguments.count == 2 else {
    FileHandle.standardError.write(Data("usage: pasteboard-to-png OUTPUT.png\n".utf8))
    exit(64)
}

let pasteboard = NSPasteboard.general
let (clipboardImage, foundImageRepresentation) = imageFromPasteboard(pasteboard)

guard let clipboardImage else {
    if foundImageRepresentation {
        FileHandle.standardError.write(Data("The clipboard image could not be decoded by macOS.\n".utf8))
        exit(1)
    }
    exit(noImageExitCode)
}

guard let data = pngData(from: clipboardImage) else {
    FileHandle.standardError.write(Data("The clipboard image could not be encoded as PNG.\n".utf8))
    exit(1)
}

do {
    let outputURL = URL(fileURLWithPath: CommandLine.arguments[1])
    try data.write(to: outputURL, options: .atomic)
} catch {
    FileHandle.standardError.write(Data("Could not write PNG: \(error.localizedDescription)\n".utf8))
    exit(1)
}
