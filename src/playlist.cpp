#include "playlist.h"

Playlist::Playlist(QObject *parent) :
    PlaylistModel(parent)
{

}

Playlist::Playlist(NetworkAccess *netAccess, ImageDatabase *db, QObject *parent) :
    PlaylistModel(db, parent)
{
    connect(this, &Playlist::requestCurrentPlaylist, netAccess, &NetworkAccess::getCurrentPlaylistTracks);
    connect(netAccess, &NetworkAccess::currentPlaylistReady, this, &Playlist::receiveNewTrackList);
    connect(this, &Playlist::clear, netAccess, &NetworkAccess::clearPlaylist);
    connect(this, &Playlist::deleteTrack, netAccess, &NetworkAccess::deleteTrackByNumber);
    connect(this, &Playlist::addArtist, netAccess, &NetworkAccess::addArtist);
    connect(this, &Playlist::playArtist, netAccess, &NetworkAccess::playArtist);
    connect(this, &Playlist::playTrackNumber, netAccess, &NetworkAccess::playTrackByNumber);
    connect(this, &Playlist::addAlbum, netAccess, &NetworkAccess::addArtistAlbumToPlaylist);
    connect(this, &Playlist::playAlbum, netAccess, &NetworkAccess::playArtistAlbum);
    connect(this, &Playlist::addTrack, netAccess, &NetworkAccess::addTrackToPlaylist);
    connect(this, &Playlist::playTrack, netAccess, &NetworkAccess::playTrack);
    connect(this, &Playlist::addPlayTrack, netAccess, &NetworkAccess::addPlayTrack);
    connect(this, &Playlist::addTrackAfterCurrent, netAccess, &NetworkAccess::addTrackAfterCurrent);

    emit requestCurrentPlaylist();
}
