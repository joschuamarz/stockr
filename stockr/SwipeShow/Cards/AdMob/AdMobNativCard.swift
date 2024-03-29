//
//  AdMobNativCard.swift
//  stockr
//
//  Created by Joschua Marz on 02.12.20.
//

import UIKit
import GoogleMobileAds

class AdMobNativCard: UIView, CardView {
    func adjustBackgroundColor(with faktor: CGFloat) {
        //
    }
    
    func swipedRight(manager: StocksManager) {
        //
    }
    
    func swipedLeft(manager: StocksManager) {
        //
    }
    
    func setStock(_ stock: Stock) {
        //
    }
    
    func setStockDelegate(_ delegate: StockCardDelegate) {
        //
    }
    
    @IBOutlet weak var firstAdView: NativeAdView!

    
    
    @IBOutlet weak var noAdView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var placeholderView: UIView!
    
    var purchaseManager: PurchaseManager!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBAction func purchaseButtonTapped(_ sender: Any) {
        purchaseManager.startPurchase()
    }
    
    var heightConstraint : NSLayoutConstraint?

    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!

    /// The native ad view that is being presented.
    var nativeAdView: GADNativeAdView!

    /// The ad unit ID.
    //let adUnitID = "ca-app-pub-3940256099942544/3986624511" //Test
    let adUnitID = "ca-app-pub-3679492847424716/3586098043"  //Live
    
    var root: UIViewController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var rootVC: UIViewController?
    var premiumDelegate: PremiumDelegate?
    
    func commonInit() {
        layoutIfNeeded()
        Bundle.main.loadNibNamed("AdMobNativeCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 20
        purchaseManager = PurchaseManager()
        
        purchaseButton.layer.cornerRadius = purchaseButton.frame.height/2
        
    }
    
    func setPremiumDelegate(_ delegate: PremiumDelegate) {
        self.premiumDelegate = delegate
        purchaseManager.delegate = delegate
    }
    
    @IBOutlet weak var adView: GADNativeAdView!
    func start() {
        /*
        guard let nibObjects = Bundle.main.loadNibNamed("UnifiedNativeAdView", owner: nil, options: nil),
          let adView = nibObjects.first as? GADUnifiedNativeAdView else {
            assert(false, "Could not load nib file for adView")
        }
 */
        setAdView(firstAdView.contentView)
        //setAdView(secondAdView.contentView)
    }
    
    func setAdView(_ view: GADNativeAdView) {
      // Remove the previous ad view.
        nativeAdView = view
        
        //self.placeholderView.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

    
      // Layout constraints for positioning the native ad view to stretch the entire width and height
      // of the nativeAdPlaceholder.
      let viewDictionary = ["_nativeAdView": nativeAdView!]
       
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                           options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                              options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    
       
 
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: root!,
                               adTypes: [ .native ], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
    }
    
   

}


extension AdMobNativCard : GADVideoControllerDelegate {

  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    //videoStatusLabel.text = "Video playback has ended."
  }
}

extension AdMobNativCard : GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

extension AdMobNativCard : GADNativeAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
    //refreshAdButton.isEnabled = true
    noAdView.isHidden = true
    nativeAdView.nativeAd = nativeAd

    // Set ourselves as the native ad delegate to be notified of native ad events.
    nativeAd.delegate = self

    // Deactivate the height constraint that was set when the previous video ad loaded.
    heightConstraint?.isActive = false

    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

    // Some native ads will include a video asset, while others do not. Apps can use the
    // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
    // UI accordingly.
    let mediaContent = nativeAd.mediaContent
    if mediaContent.hasVideoContent {
      // By acting as the delegate to the GADVideoController, this ViewController receives messages
      // about events in the video lifecycle.
      mediaContent.videoController.delegate = self
      //videoStatusLabel.text = "Ad contains a video asset."
    }
    else {
      //videoStatusLabel.text = "Ad does not contain a video."
    }

    // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
    // ratio of the media it displays.
    if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
      heightConstraint = NSLayoutConstraint(item: mediaView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: mediaView,
                                            attribute: .width,
                                            multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                                            constant: 0)
      heightConstraint?.isActive = true
    }

    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
    nativeAdView.bodyView?.isHidden = nativeAd.body == nil

    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
    nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
    nativeAdView.iconView?.isHidden = nativeAd.icon == nil

    //
    nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
    nativeAdView.storeView?.isHidden = nativeAd.store == nil

    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
    nativeAdView.priceView?.isHidden = nativeAd.price == nil

    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
    nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

    // In order for the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView?.isUserInteractionEnabled = false
  }
}

// MARK: - GADUnifiedNativeAdDelegate implementation
extension AdMobNativCard : GADNativeAdDelegate {

  func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }
}
