#include "playbackstate.h"

PlaybackState::PlaybackState(QObject *parent) :
    MPDPlaybackStatus(parent)
{

}

PlaybackState::PlaybackState(MPDPlaybackStatus state)
{

}

//PlaybackState::PlaybackState(NetworkAccess *netAccess, QObject *parent) :
//    MPDPlaybackStatus (parent)
//{
//}

void PlaybackState::setNetworkAccess(NetworkAccess *netAccess)
{
}

