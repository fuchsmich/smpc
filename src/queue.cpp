#include "queue.h"

Queue::Queue(QObject *parent) :
    PlaylistModel(parent)
{

}

Queue::Queue(NetworkAccess *netAccess, ImageDatabase *db, QObject *parent) :
    PlaylistModel(db, parent)
{
    connect(this, &Queue::requestCurrentPlaylist, netAccess, &NetworkAccess::getCurrentPlaylistTracks);
    connect(netAccess, &NetworkAccess::currentPlaylistReady, this, &Queue::receiveNewTrackList);
    connect(this, &Queue::clear, netAccess, &NetworkAccess::clearPlaylist);
    connect(this, &Queue::deleteTrack, netAccess, &NetworkAccess::deleteTrackByNumber);
    connect(this, &Queue::addArtist, netAccess, &NetworkAccess::addArtist);
    connect(this, &Queue::playArtist, netAccess, &NetworkAccess::playArtist);
    connect(this, &Queue::playTrackNumber, netAccess, &NetworkAccess::playTrackByNumber);
    connect(this, &Queue::addAlbum, netAccess, &NetworkAccess::addArtistAlbumToPlaylist);

    emit requestCurrentPlaylist();
}
