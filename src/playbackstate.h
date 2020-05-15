#ifndef PLAYBACKSTATE_H
#define PLAYBACKSTATE_H

#include <mpd/mpdplaybackstatus.h>
#include <mpd/networkaccess.h>

class PlaybackState : public MPDPlaybackStatus
{
    Q_OBJECT
public:
    explicit PlaybackState(QObject *parent = nullptr);
    PlaybackState(MPDPlaybackStatus state);

    void setNetworkAccess(NetworkAccess* netAccess);

signals:

public slots:
};

#endif // PLAYBACKSTATE_H
