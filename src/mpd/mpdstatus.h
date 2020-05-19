#ifndef MPDSTATUS_H
#define MPDSTATUS_H

#include <QObject>

struct MPDStatusValues {
    MPDStatusValues()
        : volume(0)
        , consume(false)
        , repeat(false)
        , single(false)
        , random(false)
        , playlist(0)
        , playlistLength(0)
        , crossFade(0)
        , state(MPDState_Inactive)
        , song(-1)
        , songId(-1)
        , nextSong(-1)
        , nextSongId(-1)
        , timeElapsed(-1)
        , timeTotal(-1)
        , bitrate(0)
        , samplerate(0)
        , bits(0)
        , channels(0)
        , updatingDb(-1) {
    }
    qint8 volume;
    bool consume;
    bool repeat;
    bool single;
    bool random;
    quint32 playlist;
    quint32 playlistLength;
    qint32 crossFade;
    MPDState state;
    qint32 song;
    qint32 songId;
    qint32 nextSong;
    qint32 nextSongId;
    quint16 timeElapsed;
    quint16 timeTotal;
    quint32 bitrate;
    quint32 samplerate;
    quint8 bits;
    quint8 channels;
    qint32 updatingDb;
    QString error;
};

class MPDStatus : public QObject
{
    Q_OBJECT
public:
    explicit MPDStatus(QObject *parent = 0);

private:
    QString mInfo;
    QString mTitle;
    QString mArtist;
    QString mAlbum;
    QString mURI;

    int mTrackNR;
    int mPlaylistLength;
    int mSamplerate;
    int mChannelCount;

signals:

public slots:

};

#endif // MPDSTATUS_H
