#include "player.h"
#include <QDebug>

Player::Player(QObject *parent) : QObject(parent)
{

}

Player::Player(NetworkAccess *netAccess, ImageDatabase *imgDB, QObject *parent)
    : QObject(parent)
{
    m_netAccess = netAccess;
    m_imgDB = imgDB;
    m_playbackStatus = m_netAccess->getMPDPlaybackStatus();
    connect(this, &Player::setShuffle, m_netAccess, &NetworkAccess::setRandom);
}

void Player::play()
{
    qDebug() << "play";
}

void Player::stop()
{
    qDebug() << "stop";
}

void Player::next()
{
    qDebug() << "next";
}

void Player::previous()
{
    qDebug() << "previous";
}
