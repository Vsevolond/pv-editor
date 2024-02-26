import UIKit
import AVKit

// MARK: - Video Metal View

final class VideoMetalView: UIView {
    
    // MARK: - Internal Properties
    
    var isEnded: Bool = false
    
    var isPlaying: Bool { player.rate > 0 }
    
    var duration: CMTime {
        guard let item = player.currentItem else {
            return .zero
        }
        
        return item.duration
    }
    
    var currentImage: CIImage = .init() {
        didSet {
            setFilteredImage(by: currentImage)
            updateSnapshot?(currentImage)
        }
    }
    
    // MARK: - Private Properties
    
    private let imageView: ImageMetalView = ImageMetalView()
    
    private var videoUrl: URL
    
    private lazy var player: AVPlayer = {
        let item = AVPlayerItem(url: videoUrl)
        item.add(output)
        return AVPlayer(playerItem: item)
    }()
    
    private var output: AVPlayerItemVideoOutput = AVPlayerItemVideoOutput(outputSettings: nil)
    private var displayLink: CADisplayLink?
    private var playerItemObserver: NSKeyValueObservation?
    private var timeObserverToken: Any?
    
    private var updateTime: ((CMTime) -> Void)?
    
    private var updateSnapshot: ((CIImage) -> Void)?
    
    private var currentTime: CMTime = .init(seconds: 0, preferredTimescale: .max) {
        didSet {
            updateTime?(currentTime)
        }
    }
    
    private var filter: CIFilter? {
        didSet {
            extractAndSetSnapshot(by: currentTime)
        }
    }
    
    // MARK: - Initializers
    
    init(videoUrl: URL) {
        self.videoUrl = videoUrl
        super.init(frame: .zero)
        
        setupPlayerItemObserver()
        setupTimeObserverToken()
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: player.currentItem)
    }
    
    // MARK: - Internal Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
        addSubview(imageView)
        
        extractAndSetSnapshot(by: currentTime)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func seek(to time: CMTime) {
        isEnded = false
        player.pause()
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func onTimeUpdated(_ handler: @escaping (CMTime) -> Void) {
        updateTime = handler
    }
    
    func onSnapshotUpdated(_ handler: @escaping (CIImage) -> Void) {
        updateSnapshot = handler
    }
    
    func setFilter(_ filter: CIFilter?) {
        self.filter = filter
    }
    
    // MARK: - Private Methods
    
    private func setupPlayerItemObserver() {
        playerItemObserver = player.currentItem?.observe(\.status, changeHandler: { [weak self] item, _ in
            guard item.status == .readyToPlay else { return }
            
            self?.playerItemObserver = nil
            self?.setupDisplayLink()
        })
    }
    
    private func setupTimeObserverToken() {
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    
    private func extractAndSetSnapshot(by time: CMTime) {
        let asset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { [weak self] _, image, _, _, _ in
            guard let self, let cgImage = image else { return }
            let ciImage = CIImage(cgImage: cgImage)
            
            self.currentImage = ciImage
        }
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkUpdated(link:)))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func setFilteredImage(by image: CIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            filter?.setValue(image, forKey: kCIInputImageKey)
            let outputImage = filter?.outputImage
            
            imageView.image = outputImage ?? image
        }
    }
    
    @objc private func displayLinkUpdated(link: CADisplayLink) {
        guard isPlaying else { return }
        
        let time = output.itemTime(forHostTime: CACurrentMediaTime())
        guard output.hasNewPixelBuffer(forItemTime: time),
              let pixbuf = output.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else { return }
        
        let baseImage = CIImage(cvImageBuffer: pixbuf)
        currentImage = baseImage
    }
    
    @objc private func videoDidEnd() {
        isEnded = true
    }
}
