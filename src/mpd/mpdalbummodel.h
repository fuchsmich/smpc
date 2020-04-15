#ifndef MPDALBUMMODEL_H
#define MPDALBUMMODEL_H

#include <QAbstractListModel>
#include <mpd/mpdalbum.h>


class MPDAlbumModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(QString artist READ artist WRITE setArtist NOTIFY artistChanged)
    Q_PROPERTY(int sortBy READ sortBy WRITE setSortBy NOTIFY sortByChanged)

public:
    MPDAlbumModel(QObject *parent = 0);

    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;

    enum EntryRoles {
        AlbumRole = Qt::UserRole + 1,
        ArtistRole,
        DateRole,
        SectionRole,
        AlbumCleanedRole,
        AlbumImageRole
    };

    int sortBy() const
    {
        return m_sortBy;
    }

    QString artist() const
    {
        return m_artist;
    }

public slots:
    void setSortBy(int sortBy)
    {
        if (m_sortBy == sortBy)
            return;

        m_sortBy = sortBy;
        emit sortByChanged(m_sortBy);
    }
    void setArtist(QString artist)
    {
        if (m_artist == artist)
            return;

        m_artist = artist;
        emit artistChanged(m_artist);
    }

signals:
    void sortByChanged(int sortBy);
    void countChanged(int count);

    void artistChanged(QString artist);

private:
    QList<MpdAlbum*> *m_Entries;

    int m_sortBy;
    QString m_artist;
};

#endif // MPDALBUMMODEL_H
