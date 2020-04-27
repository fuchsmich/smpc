#include "albumprovider.h"

AlbumProvider::AlbumProvider(QObject *parent) : QObject(parent), m_artistName("")
{
    NetworkAccess *netAccess = NetAccessSglt::getInstance();
    connect(this, &AlbumProvider::artistNameChanged, netAccess, &NetworkAccess::getAlbums);
    connect(this, &AlbumProvider::artistNameChanged, this, &AlbumProvider::stringSlot);
    connect(netAccess, &NetworkAccess::albumsReady, this, &AlbumProvider::updateAlbumList);
    for (int i = 0; i < 8; ++i) {
        m_testList.append(QString("testList %1").arg(m_testList.count()));
    }
    emit testListChanged(m_testList);
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

QList<MpdAlbum> AlbumProvider::albumList() const
{
    return m_albumList;
}
//QQmlListProperty<MpdAlbum *> albumList();


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


void AlbumProvider::setAlbumList(QList<MpdAlbum> albumList)
{
//    if (m_albumList == albumList)
//        return;
    qDebug() << albumList.length();

    m_albumList = albumList;
    qDebug() << m_albumList.count();
    emit albumListChanged();
//    emit albumCountChanged(m_albumList.count());
}

void AlbumProvider::updateAlbumList(QList<QObject *> *albumList)
{
    qDebug() << "updating albums" << albumList->length();
    QList<MpdAlbum *> *mpdAlbumList = (QList<MpdAlbum *> *)albumList;
    QList<MpdAlbum> tempList;
    for (MpdAlbum *a : *mpdAlbumList) {
        tempList.append(*a);
    }
    setAlbumList(tempList);
}

void AlbumProvider::stringSlot(QString str)
{
    qDebug() << str;
}
