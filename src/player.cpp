#include "player.h"
#include <QDebug>

Player::Player(QObject *parent) : QObject(parent)
{

}

Player::Player(NetworkAccess *netAccess, ImageDatabase *imgDB, QObject *parent)
    : QObject(parent)
{
    qRegisterMetaType<MPDPlaybackStatus *>("MPDPlaybackStatus*");

    m_netAccess = netAccess;
    m_imgDB = imgDB;
    //PlaybackState
    m_playbackStatus = m_netAccess->getMPDPlaybackStatus();

    connect(this, &Player::play, m_netAccess, &NetworkAccess::pause);
    connect(this, &Player::stop, m_netAccess, &NetworkAccess::stop);
    connect(this, &Player::next, m_netAccess, &NetworkAccess::next);
    connect(this, &Player::previous, m_netAccess, &NetworkAccess::previous);
    connect(this, &Player::seek, m_netAccess, &NetworkAccess::seek);
    connect(this, &Player::setVolume, m_netAccess, &NetworkAccess::setVolume);


    //playlist
    m_playlist = new Playlist(m_netAccess, m_imgDB, this);
    connect(m_playbackStatus, &MPDPlaybackStatus::idChanged, m_playlist, &Playlist::onTrackNoChanged);
    connect(m_playbackStatus, &MPDPlaybackStatus::playbackStatusChanged, m_playlist, &Playlist::onPlaybackStateChanged);

    connect(this, &Player::setRepeat, m_netAccess, &NetworkAccess::setRepeat);
    connect(this, &Player::setShuffle, m_netAccess, &NetworkAccess::setRandom);
    connect(this, &Player::setConsume, m_netAccess, &NetworkAccess::setConsume);
    connect(this, &Player::setSingle, m_netAccess, &NetworkAccess::setSingle);
}
