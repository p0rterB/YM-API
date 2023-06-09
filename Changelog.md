#  Changelog

## Version 0.7.0
**09.06.2023**

**New API methods**

- New multi-step authorization procedure with *passport.yandex.ru* through webview and with *mobileproxy.passport.yandex.net* through API
- Track download info V2, supports streaming containers. This feature requires tokens from the new multi-step authorization. Experimental
- Track lyrics support

**Sample app changes**

- iOS 16 tab bar ui adopt
- *Favourite* tracks list load speed up
- New authorization procedure
- Minimum iOS SDK version is 11.0 to support WKWebView features and the new authorization procedure

**Other changes**

- Updated YM client credentials (client ID, secret etc.) according actual app
- new *LyricsDownloadInfo* model

**Breaking changes**

- Legacy authorization through oauth.yandex.ru has been deleted. It doesn't work for auth anymore. Use the new multi-step authorization. Tokens from this auth still remains active
- Passport authorization through only mobileproxy.passport.yandex.net has been deleted. It doesn't work for auth anymore. It is a part of multi-step authorization procedure for now. Tokens from this auth still remains active
- **It is no longer possible to authorize and generate access token through only YM-API. This action can be done through WKWebView**
- Album model update: new field *availableForOptions*
- Track model update: new fields *trackSource*, *availableForOptions* and *lyricsInfo*
- Playlist model update: new field *hadAnySubscription*
- Account model update: new field *child*
- Status model update: new fields *pretrialActive* and *userhash*

## Version 0.6.3
**23.05.2022**

**New API methods**

- Import tracks for new playlist method (including import status check method)
- User info retrieve method by UID or login (can be executed without active session)

**API related changes**

- Updated *User* class, adopting for user search method (*statistics* and *socialProfiles* fields)
- New *SocialProfile* class
- New *UserStatistics* class
- New *PlaylistImportStatus* class

**Sample app changes**

- *Fast track skip* crash fix
- *My playlists* retrieve and play its tracks support
- Main radio stations full support

## Version 0.6.1
**14.03.2022**

**API related changes**

- New sign in method (passport.yandex) *YMClient's instance.authByCredentials*
- *Artist likes* fix;
- Tracks' JSON parser fix
- Radios' JSON parser fix

**Sample app changes**

- Small UI fixes
_____________________________

## Version 0.6.0
**03.11.2021**

**New API methods**

- New authorization system (passport.yandex);
- 'Recently listened' request;
- 'Feed promotions info' request;
- Search history (get, clear or add search query to the history);
- Labels (artists, albums)

**API related changes**

- *XPassportObj* class for new athentication system;
- Updated methods for retrieving user avatar;
- Listen history related classes: *ListenHistory*, *ListenHistoryItem*, *ListenHistoryContextType*;
- Updated *Promotion* class;
- Updated *YMDevice* class;
- New *SearchFeedback* and *SearchHistoryItem* classes;
- New *SearchHistoryItem* and *SearchFeedback* classes

**Sample app changes**

- Adopted for iPhone X and newer display;
- Other small UI fixes

**Other changes**

- Method *client.authByCredentials* marked as deprecated. It remains working as long as Yandex supports it
_____________________________

## Version 0.5.3
**28.09.2021**

**Initial commit**
_____________________________
