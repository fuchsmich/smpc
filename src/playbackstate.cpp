#include "playbackstate.h"

PlaybackState::PlaybackState(QObject *parent) :
    MPDPlaybackStatus(parent)
{

}

//PlaybackState::PlaybackState(NetworkAccess *netAccess, QObject *parent) :
//    MPDPlaybackStatus (parent)
//{
//}

void PlaybackState::setNetworkAccess(NetworkAccess *netAccess)
{
    connect(this, &PlaybackState::shuffleChanged, netAccess, &NetworkAccess::setRandom);
    connect(this, &PlaybackState::repeatChanged, netAccess, &NetworkAccess::setRepeat);
    //connect(this, &PlaybackState::volumeChanged, netAccess, &NetworkAccess::setVolume);
}

