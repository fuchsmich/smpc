#ifndef NETWORKACCESS_H
#define NETWORKACCESS_H

#include <QObject>
#include <QtNetwork>
#include <QQmlEngine>
#include <mpd/mpdalbum.h>
#include <mpd/mpdartist.h>
#include <mpd/mpdtrack.h>
#include <mpd/mpdfileentry.h>
#include <mpd/mpdoutput.h>
#include <mpd/mpdplaybackstatus.h>
#include <mpd/mpdcommon.h>

#include <mpd/serverinfo.h>

#include <common.h>

// Timeout value for network communication
#define READYREAD 15000
#define IDLEWAIT 2000

#define CONNECTION_TIMEOUT 10000
#define CONNECTION_READ_ATTEMPTS 5

/* Time after a resync of status with server is done. This is only to compensate
 for timedrift and will probably removed later. */
#define RESYNC_TIME 120 * 1000

class MpdAlbum;
class MpdArtist;
class MpdTrack;
class MpdFileEntry;

class NetworkAccess : public QThread
{
    Q_OBJECT
    
public:
    explicit NetworkAccess(QObject *parent = nullptr);

    ~NetworkAccess();

    struct Response {
        Response(bool o=true, const QByteArray &d=QByteArray());
        QString getError(const QByteArray &command);
        bool ok;
        QByteArray data;
    };


    Q_INVOKABLE void connectToHost(QString hostname, quint16 port,QString password = "");
    Q_INVOKABLE bool connected();
    void setUpdateInterval(quint16 ms);
    void setConnectParameters(QString hostname,int port, QString password = "");
    void setQMLThread(QThread *thread);
    MPDPlaybackStatus *getMPDPlaybackStatus();

    void setSortAlbumsByYear(int state);
    int sortAlbumsByYear();

    void setUseAlbumArtist(int state);
    int useAlbumArtist();


signals:
    void connectionEstablished();
    void disconnected();
    void connectionError(QString);
    void artistsReady(QList<QObject*>*);
    void albumsReady(QList<QObject*>*);
    void filesReady(QList<QObject*>*);
    void artistAlbumsReady(QList<QObject*>*);
    void albumTracksReady(QList<QObject*>*);
    void searchedTracksReady(QList<QObject*>*);

    void trackListReady(QList<MpdTrack*>*);
    void currentPlaylistReady(QList<MpdTrack*>*);
    void savedPlaylistsReady(QStringList*);
    void savedPlaylistTracksReady(QList<QObject*>*);
    void artistsAlbumsMapReady(QMap<MpdArtist*, QList<MpdAlbum*>* > *);
    void outputsReady(QList<QObject*>*);
    void busy();
    void ready();
    void requestExit();

public slots:
    void disconnectFromServer();
    void connectToHost();

    /* player */
    void pause();
    void stop();
    /* playlist navigation */
    void next();
    void previous();
    void seekPosition(int id,int pos);
    void seek(int pos);
    void setVolume(quint8 volume);
    /* playlist modes */
    void setRandom(bool random);
    void setRepeat(bool repeat);
    void setConsume(bool consume);
    void setSingle(quint8 single);

    /* playlist queue */
    void getCurrentPlaylistTracks();
    void addAlbumToPlaylist(QString album);
    void addArtist(QString artist);
    void addTrackToPlaylist(QString fileuri);
    void addTrackAfterCurrent(QString fileuri);
    void addArtistAlbumToPlaylist(QString artist,QString album);
    void playAlbum(QString album);
    void playArtist(QString artist);
    void playTrack(QString fileuri);
    void addPlayTrack(QString fileuri);
    void playTrackByNumber(int nr);
    void playArtistAlbum(QString artist, QString album);
    void deleteTrackByNumber(int nr);
    void clearPlaylist();
    quint32 getPlayListVersion();
    void playTrackNext(int index);
    void addPlaylist(QString name);
    void playPlaylist(QString name);
    void deletePlaylist(QString name);

    /* database */
    void getAlbums();
    void getArtists();
    void getTracks();
    void getArtistsAlbums(QString artist);
    void getAlbumTracks(QString album);
    void getAlbumTracks(QString album, QString cartist);
    void getAlbumTracks(QVariant albuminfo);
    void getArtistAlbumMap();
    void getDirectory(QString path);
    void searchTracks(QVariant request);
    /* saved playlists */
    void getSavedPlaylists();
    void getPlaylistTracks(QString name);
    void addTrackToSavedPlaylist(QVariant data);
    void removeTrackFromSavedPlaylist(QVariant data);
    void savePlaylist(QString name);

    /* outputs */
    void getOutputs();
    void enableOutput(int nr);
    void disableOutput(int nr);

    void updateDB();
    void setUpdateInterval(int ms);

    void exitRequest();

protected slots:
    void onServerConnected();
    void onServerDisconnected();
    void onConnectionError();

    void getStatus();
    void interpolateStatus();
    void goIdle();
    void cancelIdling();
    void onNewNetworkData();

    void onConnectionStateChanged(QAbstractSocket::SocketState socketState);
    void onConnectionTimeout();


private:
    QString mHostname;
    quint16 mPort;
    QString mPassword;

    QTcpSocket* mTCPSocket;

    QTimer *mStatusTimer;
    QTimer *mIdleCountdown;
    quint16 mStatusInterval;
    quint32 mPlaylistversion;
    QThread *mQMLThread;

    MPDPlaybackStatus *mPlaybackStatus;

    ServerInfo *mServerInfo;
    QTime mLastSyncTime;
    QTime mLastStatusTimestamp;
    quint32 mLastSyncElapsedTime;

    bool mIdling;

    QList<MpdAlbum *> *parseMPDAlbums(QString artist);
    QList<MpdTrack*>* parseMPDTracks(QString cartist);
    QList<MpdAlbum*>* getAlbums_prv();
    QList<MpdArtist*>* getArtists_prv();
    QList<MpdTrack*>* getAlbumTracks_prv(QString album);
    QList<MpdTrack*>* getAlbumTracks_prv(QString album, QString cartist);
    QList<MpdAlbum*>* getArtistsAlbums_prv(QString artist);
    QMap<MpdArtist*, QList<MpdAlbum*>* > *getArtistsAlbumsMap_prv();
    QTimer *mTimeoutTimer;
    void checkServerCapabilities();
    MPD_PLAYBACK_STATE getPlaybackState();
    quint32 getPlaybackID();
    quint32 getPlaylistLength();

    QByteArray readFromSocket(QTcpSocket &socket, int timeout);
    NetworkAccess::Response readReply(QTcpSocket &socket, int timeout);
    NetworkAccess::Response sendMPDCommand(QString cmd);
    bool authenticate(QString passwort);

    bool mSortAlbumsByYear;
    bool mUseAlbumArtist;

    QString escapeCommandArgument(const QString arg);
};

#endif // NETWORKACCESS_H
