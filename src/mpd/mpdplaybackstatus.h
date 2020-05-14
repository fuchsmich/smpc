#ifndef MPDPLAYBACKSTATUS_H
#define MPDPLAYBACKSTATUS_H

#include <QObject>
#include <mpd/mpdcommon.h>

class NetworkAccess;
class MPDPlaybackStatus : public QObject
{
    friend class NetworkAccess;
    Q_OBJECT
    //TODO check, which properties are readonly for qml!
    Q_PROPERTY(quint32 playlistVersion READ getPlaylistVersion WRITE setPlaylistVersion NOTIFY playlistVersionChanged)
    Q_PROPERTY(quint32 id READ getID WRITE setID NOTIFY idChanged)
    Q_PROPERTY(quint32 bitrate READ getBitrate WRITE setBitrate NOTIFY bitrateChanged)
    Q_PROPERTY(qint32 trackNo READ getTrackNo WRITE setTrackNo NOTIFY trackNoChanged)
    Q_PROPERTY(qint32 albumTrackCount READ getAlbumTrackCount WRITE setAlbumTrackCount NOTIFY albumTrackCountChanged)
    Q_PROPERTY(quint8 volume READ getVolume WRITE setVolume NOTIFY volumeChanged)

    Q_PROPERTY(QString title READ getTitle WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString album READ getAlbum WRITE setAlbum NOTIFY albumChanged)
    Q_PROPERTY(QString artist READ getArtist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(QString uri READ getURI WRITE setURI NOTIFY uriChanged)

    Q_PROPERTY(quint8 playbackStatus READ getPlaybackStatus WRITE setPlaybackStatus NOTIFY playbackStatusChanged)
    Q_PROPERTY(bool repeat READ getRepeat WRITE setRepeat NOTIFY repeatChanged)
    Q_PROPERTY(bool shuffle READ getShuffle WRITE setShuffle NOTIFY shuffleChanged)
    Q_PROPERTY(bool consume READ getConsume WRITE setConsume NOTIFY consumeChanged)
    Q_PROPERTY(quint8 single READ getSingle WRITE setSingle NOTIFY singleChanged)

    Q_PROPERTY(quint32 length READ getLength WRITE setLength NOTIFY lengthChanged)
    Q_PROPERTY(quint32 currentTime READ getCurrentTime WRITE setCurrentTime NOTIFY currentTimeChanged)
    Q_PROPERTY(quint32 playlistSize READ getPlaylistSize WRITE setPlaylistSize NOTIFY playlistSizeChanged)

    Q_PROPERTY(quint32 samplerate READ getSamplerate WRITE setSamplerate NOTIFY samplerateChanged)
    Q_PROPERTY(quint8 channelCount READ getChannelCount WRITE setChannelCount NOTIFY channelCountChanged)
    Q_PROPERTY(quint8 bitDepth READ getBitDepth WRITE setBitDepth NOTIFY bitDepthChanged)

public:
    explicit MPDPlaybackStatus(QObject *parent = nullptr);
    MPDPlaybackStatus(const MPDPlaybackStatus &copyObject, QObject *parent = nullptr);

    quint32 getPlaylistVersion();
    quint32 getID();
    quint32 getBitrate();
    qint32 getTrackNo();
    qint32 getAlbumTrackCount();
    quint8 getVolume();

    QString getTitle();
    QString getAlbum();
    QString getArtist();
    QString getURI();

    quint8 getPlaybackStatus();
    bool getRepeat();
    bool getShuffle();
    bool getConsume();
    quint8 getSingle();

    quint32 getLength();
    quint32 getCurrentTime();
    quint32 getPlaylistSize();

    quint32 getSamplerate();
    quint8 getChannelCount();
    quint8 getBitDepth();

    void setPlaylistVersion(quint32 playlistVersion);
    void setID(quint32 id);
    void setBitrate(quint32 bitrate);
    void setTrackNo(qint32 trackNo);
    void setAlbumTrackCount(qint32 getAlbumTrackCount);
    void setVolume(quint8 volume);

    void setTitle(QString title);
    void setAlbum(QString album);
    void setArtist(QString artist);
    void setURI(QString uri);

    Q_ENUMS(MPD_PLAYBACK_STATE)
    void setPlaybackStatus(quint8 playbackStatus);
    void setRepeat(bool repeat);
    void setShuffle(bool shuffle);
    void setConsume(bool consume);
    Q_ENUMS(MPD_PLAYBACK_SINGLE)
    void setSingle(quint8 single);

    void setLength(quint32 length);
    void setCurrentTime(quint32 currentTime);
    void setPlaylistSize(quint32 playlistSize);
    void setSamplerate(quint32 samplerate);
    void setChannelCount(quint8 channelCount);
    void setBitDepth(quint8 bitDepth);

    /**
     * @brief clearPlayback
     * on stopped playback clear all the fields
     */
    void clearPlayback();

signals:
    void playlistVersionChanged();
    void idChanged(quint32);
    void bitrateChanged();
    void trackNoChanged(qint32 trackno);
    void albumTrackCountChanged();
    void volumeChanged(quint8 volume);

    void titleChanged();
    void albumChanged();
    void artistChanged();
    void uriChanged();

    void playbackStatusChanged(MPD_PLAYBACK_STATE state);
    void repeatChanged(bool repeat);
    void shuffleChanged(bool shuffle);
    void consumeChanged(bool consume);
    void singleChanged(quint8 single);

    void lengthChanged();
    void currentTimeChanged();
    void playlistSizeChanged();
    void samplerateChanged();
    void channelCountChanged();
    void bitDepthChanged();


public slots:

private:
    quint32 pPlaylistVersion;
    quint32 pID;
    quint32 pBitrate;
    qint32 pTrackNo;
    qint32 pAlbumTrackCount;
    quint8 pVolume;
    QString pTitle;
    QString pAlbum;
    QString pArtist;
    QString pURI;
    MPD_PLAYBACK_STATE pPlaybackStatus;
    bool pRepeat;
    bool pShuffle;
    bool pConsume;
    quint8 pSingle;
    quint32 pLength;
    quint32 pCurrentTime;
    quint32 pPlaylistSize;
    quint32 pSamplerate;
    quint8 pChannelCount;
    quint8 pBitDepth;

protected:
    ~MPDPlaybackStatus();
};

#endif // MPDPLAYBACKSTATUS_H
