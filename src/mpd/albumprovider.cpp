#include "albumprovider.h"

AlbumProvider::AlbumProvider(QObject *parent) : QObject(parent), m_artistName("")
{
    m_netAccess = NetAccessSglt::getInstance();
    qDebug() << &m_netAccess;
    //connect(this, &AlbumProvider::artistNameChanged, m_netAccess, &NetworkAccess::getAlbums);
    connect(this, &AlbumProvider::artistNameChanged, this, &AlbumProvider::fetchAlbums);
    connect(this, &AlbumProvider::artistNameChanged, this, &AlbumProvider::stringSlot);
    connect(m_netAccess, &NetworkAccess::albumsReady, this, &AlbumProvider::setAlbumList);

    emit artistNameChanged(m_artistName);
}

bool AlbumProvider::useAlbumArtist() const
{
    return m_useAlbumArtist;
}

QString AlbumProvider::artistName() const
{
    return m_artistName;
}

void AlbumProvider::setUseAlbumArtist(bool useAlbumArtist)
{
    if (m_useAlbumArtist == useAlbumArtist)
        return;

    m_useAlbumArtist = useAlbumArtist;
    emit useAlbumArtistChanged(m_useAlbumArtist);
}

void AlbumProvider::setArtistName(QString artistName)
{
    if (m_artistName == artistName)
        return;

    m_artistName = artistName;
    emit artistNameChanged(m_artistName);
}



void AlbumProvider::fetchAlbums(QString artist)
{
    qDebug() << &m_netAccess << artist;
    connect(m_netAccess, &NetworkAccess::albumsReady, this, &AlbumProvider::setAlbumList);
    if (artist.isEmpty()) {
        m_netAccess->getAlbums();
    }
    else {
        m_netAccess->getArtistsAlbums(artist);
    }
}


void AlbumProvider::setAlbumList(QList<QObject *> *albumList)
{
    if (m_albumList == *albumList)
        return;
    qDebug() << albumList->length();

    m_albumList = *albumList;
    qDebug() << m_albumList.count();
    emit albumListChanged();
    emit albumCountChanged(m_albumList.count());
}

void AlbumProvider::stringSlot(QString str)
{
    qDebug() << str;
}
