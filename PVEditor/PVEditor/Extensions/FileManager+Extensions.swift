import Foundation

// MARK: - FileManager Extensions

extension FileManager {
    
    func copyFile(at path: URL) -> URL {
        let tempPath = URL(fileURLWithPath: NSTemporaryDirectory() + path.lastPathComponent)

        if !FileManager.default.fileExists(atPath: tempPath.absoluteString) {
            do {
                try FileManager.default.copyItem(at: path, to: tempPath)
            } catch {
                fatalError(error.localizedDescription)
            }
        }

        return tempPath
    }
}
