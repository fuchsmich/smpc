#ifndef PLAYLIST_H
#define PLAYLIST_H

#include <mpd/playlistmodel.h>
#include <mpd/networkaccess.h>


class Playlist : public PlaylistModel
{
    Q_OBJECT

public:
    explicit Playlist(QObject *parent = nullptr);
    Playlist(NetworkAccess* netAccess, ImageDatabase *db, QObject *parent = nullptr);

signals:
    void requestCurrentPlaylist();
    void clear();
    void deleteTrack(int);
    void addArtist(QString);
    void playArtist(QString);
    void playTrackNumber(int);
    void playTrackNext(int);
    void addAlbum(QString, QString);
    void playAlbum(QString, QString);
    void addTrack(QString);
    void playTrack(QString);
    void addPlayTrack(QString);
    void addTrackAfterCurrent(QString);
};

#endif // PLAYLIST_H
