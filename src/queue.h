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
    void deleteTrack(int id);
    void addArtist(QString artist);
    void playArtist(QString artist);
    void playTrackNumber(int nr);
    void addAlbum(QString, QString);
    void addTrack();
};

#endif // QUEUE_H
