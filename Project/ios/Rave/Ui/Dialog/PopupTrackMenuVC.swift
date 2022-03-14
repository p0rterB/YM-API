//
//  PopupTrackMenuVC.swift
//  Rave
//
//  Created by Developer on 03.02.2022.
//

import UIKit
import YmuzApi

class PopupTrackMenuVC: PopupContextMenuVC {
    
    class func initializeVC(parentVC: UIViewController, track: Track, selectHandler: ((_ index: Int, _ items: [String]) -> Void)?) -> PopupContextMenuVC {
        var liked = false
        var disliked = false
        if let g_lib = appService.likedLibrary {
            liked = g_lib.contains(track: track)
        }
        if let g_lib = appService.dislikedLibrary {
            disliked = g_lib.contains(track: track)
        }
        var keys = [
            AppService.localizedString(.track_option_like),
            AppService.localizedString(.track_option_share),
            AppService.localizedString(.track_option_dislike)
        ]
        var values = [
            AppService.localizedString(.track_option_share): UIImage(named: "sys_ic_share")
        ]
        if (liked) {
            keys[0] = AppService.localizedString(.general_remove) + " \"" + AppService.localizedString(.track_option_like) + "\""
            values[keys[0]] = UIImage(named: "ic_liked")
        } else {
            values[keys[0]] = UIImage(named: "ic_like")
        }
        if (disliked) {
            keys[2] = AppService.localizedString(.general_remove) + " \"" + AppService.localizedString(.track_option_dislike) + "\""
            values[keys[2]] = UIImage(named: "ic_stopped")
        } else {
            values[keys[2]] = UIImage(named: "ic_stop")
        }
        let vc = initializeVC(keys: keys, values: values, selectHandler: { index, items in
            switch(index) {
            case 0:
                toggleLikeTrack(track)
                break
            case 1:
                var shareItem = track.shareUrl
                if (!track.trackTitle.isEmpty && track.artistsName.count > 0) {
                    shareItem = track.artistsName.joined(separator: ",") + " - " + track.trackTitle + " - " + shareItem
                }
                let shareVC = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
                parentVC.present(shareVC, animated: true, completion: nil)
                break
            case 2:
                toggleDislikeTrack(track)
                break
            default: break
            }
            selectHandler?(index, items)
        })
        return vc
    }
    
    @available(iOS 13.0, *)
    class func initializeContextMenu(parentVC: UIViewController, track: Track) -> UIMenu {
        // Create an action for sharing
        var liked = false
        var disliked = false
        if let g_lib = appService.likedLibrary {
            liked = g_lib.contains(track: track)
        }
        if let g_lib = appService.dislikedLibrary {
            disliked = g_lib.contains(track: track)
        }
        var title = AppService.localizedString(.track_option_like)
        if (liked) {
            title = AppService.localizedString(.general_remove) + " \"" + title + "\""
        }
        let like = UIAction(title: title , image: UIImage(named: liked ? "ic_liked" : "ic_like")) { action in
            toggleLikeTrack(track)
        }
        title = AppService.localizedString(.track_option_dislike)
        if (disliked) {
            title = AppService.localizedString(.general_remove) + " \"" + title + "\""
        }
        let dislike = UIAction(title: title, image: UIImage(named: disliked ? "ic_stopped" : "ic_stop")) { action in
            toggleDislikeTrack(track)
        }
        let share = UIAction(title: AppService.localizedString(.track_option_share), image: UIImage(named: "sys_ic_share")) { action in
            var shareItem = track.shareUrl
            if (!track.trackTitle.isEmpty && track.artistsName.count > 0) {
                shareItem = track.artistsName.joined(separator: ",") + " - " + track.trackTitle + " - " + shareItem
            }
            let shareVC = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
            parentVC.present(shareVC, animated: true, completion: nil)
        }
        return UIMenu(title: "", children: [like, share, dislike])
    }
    
    fileprivate class func toggleLikeTrack(_ track: Track) {
        if let g_lib = appService.likedLibrary, g_lib.contains(track: track) {
            //remove like
            let removeSuccess = appService.likedLibrary?.remove(track: track) ?? false
#if DEBUG
            print("Delete like status for track with id " + track.id + ":" + String(removeSuccess))
#endif
            track.removeLike { result in
#if DEBUG
                print(result)
#endif
            }
        } else {
            let addSuccess = appService.likedLibrary?.add(track: track) ?? false
#if DEBUG
            print("Add like status for track with id " + track.id + ":" + String(addSuccess))
#endif
            track.like { result in
#if DEBUG
                print(result)
#endif
            }
        }
    }
    
    fileprivate class func toggleDislikeTrack(_ track: Track) {
        if let g_lib = appService.dislikedLibrary, g_lib.contains(track: track) {
            //remove dislike
            let removeSuccess = appService.dislikedLibrary?.remove(track: track) ?? false
#if DEBUG
            print("Delete dislike status for track with id " + track.id + ":" + String(removeSuccess))
#endif
            track.removeDislike { result in
#if DEBUG
                print(result)
#endif
            }
        } else {
            let res = playerQueue.dislikeTrack(track)
#if DEBUG
            print("Player queue delete track by dislike:" + String(res))
#endif
            let addSuccess = appService.dislikedLibrary?.add(track: track) ?? false
#if DEBUG
            print("Add dislike status for track with id " + track.id + ":" + String(addSuccess))
#endif
            track.dislike { result in
#if DEBUG
                print(result)
#endif
            }
        }
    }
}
