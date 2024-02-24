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
        
        extractAndShowFirstFrame()
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
            self?.updateTime?(time)
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(videoDidEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    
    private func extractAndShowFirstFrame() {
        let asset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 0, preferredTimescale: .max)
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { [weak self] _, image, _, _, error in
            guard let self, let cgImage = image else { return }
            DispatchQueue.main.async {
                self.imageView.image = CIImage(cgImage: cgImage)
            }
        }
    }
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkUpdated(link:)))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func displayLinkUpdated(link: CADisplayLink) {
        
        let time = output.itemTime(forHostTime: CACurrentMediaTime())
        guard output.hasNewPixelBuffer(forItemTime: time),
              let pixbuf = output.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) else { return }
        
        let baseImg = CIImage(cvImageBuffer: pixbuf)
//        let blurImg = baseImg.clampedToExtent().applyingGaussianBlur(sigma: blurRadius).cropped(to: baseImg.extent)
        
        imageView.image = baseImg
    }
    
    @objc private func videoDidEnd() {
        isEnded = true
    }
}
