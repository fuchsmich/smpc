#ifndef QUEUE_H
#define QUEUE_H

#include <mpd/playlistmodel.h>
#include <mpd/networkaccess.h>


class Queue : public PlaylistModel
{
    Q_OBJECT

public:
    explicit Queue(QObject *parent = nullptr);
    Queue(NetworkAccess* netAccess, ImageDatabase *db, QObject *parent = nullptr);

signals:
    void requestCurrentPlaylist();
    void clear();
    void deleteTrack(int);
    void addArtist(QString);
    void playArtist(QString);
    void playTrackNumber(int);
    void addAlbum(QString, QString);
    void playAlbum(QString, QString);
    void addTrack(QString);
    void playTrack(QString);
    void addPlayTrack(QString);
    void addTrackAfterCurrent(QString);
};

#endif // QUEUE_H
