#ifndef PLAYBACKSTATE_H
#define PLAYBACKSTATE_H

#include <mpd/mpdplaybackstatus.h>
#include <mpd/networkaccess.h>

class PlaybackState : public MPDPlaybackStatus
{
    Q_OBJECT
public:
    explicit PlaybackState(QObject *parent = nullptr);
    //PlaybackState(NetworkAccess* netAccess, QObject *parent = nullptr);

    void setNetworkAccess(NetworkAccess* netAccess);

signals:

public slots:
};

#endif // PLAYBACKSTATE_H
