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
    //MPDPlaybackStatus
    m_playbackStatus = m_netAccess->getMPDPlaybackStatus();

    //playlist
    m_playlist = new Playlist(m_netAccess, m_imgDB, this);
    connect(m_playbackStatus, &MPDPlaybackStatus::idChanged, m_playlist, &Playlist::onTrackNoChanged);
    connect(m_playbackStatus, &MPDPlaybackStatus::playbackStatusChanged, m_playlist, &Playlist::onPlaybackStateChanged);

    connect(m_netAccess, &NetworkAccess::connectionEstablished, this, &Player::enableConnections);
    connect(m_netAccess, &NetworkAccess::disconnected, this, &Player::disableConnections);
}

void Player::enableConnections()
{
    connect(this, &Player::play, m_netAccess, &NetworkAccess::pause);
    connect(this, &Player::stop, m_netAccess, &NetworkAccess::stop);
    connect(this, &Player::next, m_netAccess, &NetworkAccess::next);
    connect(this, &Player::previous, m_netAccess, &NetworkAccess::previous);
    connect(this, &Player::seek, m_netAccess, &NetworkAccess::seek);
    connect(this, &Player::setVolume, m_netAccess, &NetworkAccess::setVolume);

    connect(m_playbackStatus, &MPDPlaybackStatus::shuffleChanged, m_netAccess, &NetworkAccess::setRandom);
    connect(m_playbackStatus, &MPDPlaybackStatus::repeatChanged, m_netAccess, &NetworkAccess::setRepeat);
    connect(m_playbackStatus, &MPDPlaybackStatus::consumeChanged, m_netAccess, &NetworkAccess::setConsume);
    connect(m_playbackStatus, &MPDPlaybackStatus::singleChanged, m_netAccess, &NetworkAccess::setSingle);
    //connect(m_playbackStatus, &MPDPlaybackStatus::volumeChanged, m_netAccess, &NetworkAccess::setVolume);
}

void Player::disableConnections()
{
    disconnect(this, &Player::play, m_netAccess, &NetworkAccess::pause);
    disconnect(this, &Player::stop, m_netAccess, &NetworkAccess::stop);
    disconnect(this, &Player::next, m_netAccess, &NetworkAccess::next);
    disconnect(this, &Player::previous, m_netAccess, &NetworkAccess::previous);
    disconnect(this, &Player::seek, m_netAccess, &NetworkAccess::seek);
    disconnect(this, &Player::setVolume, m_netAccess, &NetworkAccess::setVolume);

    disconnect(m_playbackStatus, &MPDPlaybackStatus::shuffleChanged, m_netAccess, &NetworkAccess::setRandom);
    disconnect(m_playbackStatus, &MPDPlaybackStatus::repeatChanged, m_netAccess, &NetworkAccess::setRepeat);
    disconnect(m_playbackStatus, &MPDPlaybackStatus::consumeChanged, m_netAccess, &NetworkAccess::setConsume);
    disconnect(m_playbackStatus, &MPDPlaybackStatus::singleChanged, m_netAccess, &NetworkAccess::setSingle);
    //disconnect(m_playbackStatus, &MPDPlaybackStatus::volumeChanged, m_netAccess, &NetworkAccess::setVolume);
}
