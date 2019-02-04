//
//  InfoViewController.swift
//  TVVLCPlayer
//
//  Created by Jérémy Marchand on 31/12/2018.
//  Copyright © 2018 Jérémy Marchand. All rights reserved.
//

import UIKit
import TVVLCKit
import Kingfisher

class InfoViewController: UIViewController {
    var player: VLCMediaPlayer!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var qualityImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var artworkWidthConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        // TODO: Find a better way to handle variable height of the info panel
        var height = mainStackView.frame.height
        if artworkImageView.isHidden {
            height = durationLabel.bounds.height + titleLabel.bounds.height + 40
            if !textView.isHidden {
                height += textView.contentSize.height
            }
        } else {
            height = 240
        }
        preferredContentSize = CGSize(width: 1920,
                                      height: height)
    }

    func configure() {
        configureTitle()
        configureProperties()
        configureArtwork()
        configureDescription()
    }

    func configureArtwork() {
        self.artworkImageView.isHidden = true

        let mediaDict = player.media?.metaDictionary
        if let imageURLStr = mediaDict?[VLCMetaInformationArtworkURL] as? String,
            let imageURL = URL(string: imageURLStr) {

            self.artworkImageView.kf.indicatorType = .activity
            self.artworkImageView.kf.setImage(with: imageURL) { result in
                switch result {
                case .success(let val):
                    self.artworkImageView.isHidden = false
                    self.artworkWidthConstraint.constant = 200 / val.image.size.height * val.image.size.width
                case .failure(let error):
                    print("Error loading image", error)
                }
            }
        } else if let image = mediaDict?[VLCMetaInformationArtwork] as? UIImage {
            artworkImageView.image = image
            artworkImageView.isHidden = false
            artworkWidthConstraint.constant = 200 / image.size.height * image.size.width
        }
    }

    func configureTitle() {
        let mediaDict = player.media?.metaDictionary
        if let title = mediaDict?[VLCMetaInformationTitle] as? String {
           titleLabel.text = title
        } else {
           titleLabel.text = player.media?.url.absoluteString
        }
    }

    func configureProperties() {
        let media = player.media
        var durationStr: String = ""
        if let time = media?.length.string {
            durationStr = time
        }

        if let manualDurationStr = media?.metaDictionary["duration"] as? String {
            durationStr = manualDurationStr
        }

        durationLabel.text = durationStr

        let videoSize: CGSize
        if let width = media?.metaDictionary[VLCMediaTracksInformationVideoWidth] as? NSNumber,
            let height = media?.metaDictionary[VLCMediaTracksInformationVideoWidth] as? NSNumber {
            videoSize = CGSize(width: width.doubleValue, height: height.doubleValue)
        } else {
            videoSize = player.videoSize
        }

        qualityImageView.image = nil

        let bundle = Bundle(for: InfoViewController.self)
        if videoSize >= CGSize(width: 3840, height: 2160) {
            qualityImageView.image = UIImage(named: "4k", in: bundle, compatibleWith: nil)
        } else if player.videoSize >= CGSize(width: 1280, height: 720) {
            qualityImageView.image = UIImage(named: "hd", in: bundle, compatibleWith: nil)
        }

        ratingImageView.image = nil

        if let ratingStr = media?.metaDictionary[VLCMetaInformationRating] as? String {
            ratingImageView.image = UIImage(named: ratingStr, in: bundle, compatibleWith: nil)
        }

    }

    func configureDescription() {
        let mediaDict = player.media.metaDictionary
        let texts = [VLCMetaInformationDescription, VLCMetaInformationCopyright].compactMap { mediaDict[$0] as? String  }

        textView.text = texts.joined(separator: "\n")
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isHidden = texts.isEmpty
    }
}

private func >= (lhs: CGSize, rhs: CGSize) -> Bool {
    return lhs.height >= rhs.height && lhs.width >= rhs.width
}

private extension VLCTime {
    var string: String? {
        guard let rawDuration = value?.doubleValue else {
            return nil
        }

        let duration = rawDuration / 1000
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .abbreviated

        if duration >= 3600 {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }

        return formatter.string(from: duration) ?? nil
    }
}
