#ifndef ALBUMPROVIDER_H
#define ALBUMPROVIDER_H

#include <QObject>
#include <QList>
#include <QVariantList>
#include <QDebug>

#include <mpd/mpdalbum.h>
#include <mpd/networkaccess.h>

class AlbumProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString artistName READ artistName WRITE setArtistName NOTIFY artistNameChanged)
    Q_PROPERTY(bool useAlbumArtist READ useAlbumArtist WRITE setUseAlbumArtist NOTIFY useAlbumArtistChanged)
    Q_PROPERTY(QList<QObject *> albumList MEMBER m_albumList NOTIFY albumListChanged)
    //Q_PROPERTY(QList<MpdAlbum *> albumList READ albumList NOTIFY albumListChanged)
    Q_PROPERTY(int albumCount READ albumCount NOTIFY albumCountChanged)

public:
    explicit AlbumProvider(QObject *parent = nullptr);

    bool useAlbumArtist() const;

    QString artistName() const;

    int albumCount() const
    {
        return m_albumList.count();
    }

    Q_INVOKABLE QString getCoverUrl(int index)
    {
        // Return dummy for the time being
        return DUMMY_ALBUMIMAGE;
    }

public slots:

    void setUseAlbumArtist(bool useAlbumArtist);

    void setArtistName(QString artistName);


signals:

    void useAlbumArtistChanged(bool useAlbumArtist);

    void artistNameChanged(QString artistName);

    void albumListChanged();

    void albumCountChanged(int albumCount);

private slots:
    void setAlbumList(QList<QObject *> *albumList);

    void stringSlot(QString str);

    void fetchAlbums(QString artist);

private:
    NetworkAccess *m_netAccess;

    bool m_useAlbumArtist;

    QString m_artistName;

    QList<QObject *> m_albumList;
};

#endif // ALBUMPROVIDER_H
