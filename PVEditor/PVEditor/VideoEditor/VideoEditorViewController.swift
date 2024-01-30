import UIKit
import AVKit

final class VideoEditorViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let player: AVPlayer
    private let playerLayer: AVPlayerLayer
    private let videoView = UIView()
    private let videoUrl: URL
    
    // MARK: - Initializers
    
    init(videoUrl: URL) {
        self.player = AVPlayer(url: videoUrl)
        self.playerLayer = AVPlayerLayer(player: player)
        self.videoUrl = videoUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        try? FileManager.default.removeItem(at: videoUrl)
    }
    
    // MARK: - Internal Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player.play()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = .white
        
        configureVideoView()
        view.addSubview(videoView)
    }
    
    private func configureVideoView() {
        guard let maxY = navigationController?.navigationBar.frame.maxY else {
            return
        }
        
        videoView.frame = .init(x: 0, y: maxY, width: view.frame.width, height: view.frame.height / 2)
        videoView.layer.borderWidth = 1
        
        playerLayer.videoGravity = .resizeAspect
//        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.frame = videoView.bounds
        
//        videoView.layer.masksToBounds = true
        videoView.layer.addSublayer(playerLayer)
    }
}
