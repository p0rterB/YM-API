#  Changelog

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
