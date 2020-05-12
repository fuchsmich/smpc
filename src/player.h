#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <playlist.h>
#include <playbackstate.h>
#include <mpd/mpdplaybackstatus.h>
#include <mpd/networkaccess.h>
#include <localdb/imagedatabase.h>

class Player : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Playlist* playlist READ queue NOTIFY queueChanged)
    Q_PROPERTY(PlaybackState* playbackStatus READ playbackStatus CONSTANT)

    Playlist* m_playlist;

    PlaybackState* m_playbackStatus;

    NetworkAccess* m_netAccess;
    ImageDatabase* m_imgDB;

public:
    explicit Player(QObject *parent = nullptr);
    Player(NetworkAccess* netAccess, ImageDatabase* imgDB, QObject *parent = nullptr);


    Playlist* queue() const
    {
        return m_playlist;
    }

    PlaybackState* playbackStatus() const
    {
        return m_playbackStatus;
    }


signals:

    void queueChanged();

    void play();
    void stop();
    void next();
    void previous();
    void seek(int pos);


public slots:
};

#endif // PLAYER_H
