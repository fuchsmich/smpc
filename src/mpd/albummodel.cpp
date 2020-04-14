#include "albummodel.h"

AlbumModel::AlbumModel(QObject *parent) :
    QAbstractListModel(parent)
{
}

AlbumModel::AlbumModel(QList<MpdAlbum *> *list, ImageDatabase *db, QString lastfmartsize, bool downloading, QObject *parent) : QAbstractListModel(parent)
{
    mEntries = list;
    mDB = db;
    mDownloader = new ImageDownloader();
    mDownloader->setDownloadSize(lastfmartsize);
    mDownloadEnabled = downloading;

    connect(this,SIGNAL(requestAlbumInformation(MpdAlbum)),mDownloader,SLOT(requestAlbumArt(MpdAlbum)),Qt::QueuedConnection);
    connect(mDownloader,SIGNAL(albumInformationReady(AlbumInformation*)),this,SLOT(albumInformationReady(AlbumInformation*)));
    connect(this,SIGNAL(requestDBEnter(AlbumInformation*)),mDB,SLOT(enterAlbumInformation(AlbumInformation*)));
    connect(mDB,SIGNAL(albumEntered(QString)),this,SLOT(albumEntered(QString)));
}

AlbumModel::~AlbumModel()
{
    if(mEntries){
        qDeleteAll(*mEntries);
        delete(mEntries);
    }
    delete(mDownloader);
}


QVariant AlbumModel::data(const QModelIndex &index, int role) const
{
    if (Q_UNLIKELY(index.row() < 0 || index.row() > rowCount())) {
        return QVariant(QVariant::Invalid);
    }
    if (role==AlbumRole)
    {
        return mEntries->at(index.row())->getTitle();
    }
    else if (role==ArtistRole)
    {
        return mEntries->at(index.row())->getArtist();
    }
    else if (role==DateRole)
    {
        return mEntries->at(index.row())->getDate();
    }
    else if (role==SectionRole)
    {
        return getSection(index.row());
    }
    else if (role==AlbumCleandRole)
    {
        QString cleanedAlbum = mEntries->at(index.row())->getTitle();
        cleanedAlbum = cleanedAlbum.replace('/',"");
        return cleanedAlbum;
    }
    else if (role==AlbumImageRole)
    {
        MpdAlbum *album = mEntries->at(index.row());
        qDebug() << "Image for album: " << album->getTitle() << "requested";
        if ( album->getArtist() != "" ) {
            int imageID = mDB->imageIDFromAlbumArtist(album->getTitle(),album->getArtist());
            // No image found return dummy url
            if ( imageID == -1 ) {
                // Start image retrieval
                qDebug() << "Returning dummy image for album: " << album->getTitle() << " and artist " << album->getArtist();
                if ( mDownloadEnabled ) {
                    emit requestAlbumInformation(*album);
                }
                // Return dummy for the time being
                return DUMMY_ALBUMIMAGE;
            } else if (imageID == -2 ) {
                // Try getting album art for album with out artist (think samplers)
                imageID = mDB->imageIDFromAlbum(album->getTitle());
                if ( imageID >= 0 ) {
                    QString url = "image://imagedbprovider/albumid/" + QString::number(imageID);
                    return url;
                }
                qDebug() << "returning dummy image for blacklisted album: " << album->getTitle();
                return DUMMY_ALBUMIMAGE;
            } else {
                qDebug() << "returning database image for album: " << album->getTitle();
                QString url = "image://imagedbprovider/albumid/" + QString::number(imageID);
                return url;
            }
        }
        else {
            int imageID = mDB->imageIDFromAlbum(album->getTitle());

            // No image found return dummy url
            if ( imageID == -1 ) {
                // Start image retrieval
                qDebug() << "returning dummy image for album: " << album->getTitle();
                // Return dummy for the time being
                return DUMMY_ALBUMIMAGE;
            } else if (imageID == -2 ) {
                qDebug() << "returning dummy image for blacklisted album: " << album->getTitle();
                return DUMMY_ALBUMIMAGE;
            }
            else {
                qDebug() << "returning database image for album: " << album->getTitle();
                QString url = "image://imagedbprovider/albumid/" + QString::number(imageID);
                return url;
            }
        }
    }
    return QVariant(QVariant::Invalid);;
}

int AlbumModel::rowCount(const QModelIndex &parent) const{
    if (parent.isValid()) {
        return 0;
    }
    return mEntries->length();
}

QHash<int, QByteArray> AlbumModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[AlbumRole] = "title";
    roles[ArtistRole] = "artist";
    roles[DateRole] = "artist";
    roles[SectionRole] = "sectionprop";
    roles[AlbumCleandRole] = "titleClean";
    roles[AlbumImageRole] = "coverURL";
    return roles;
}

QString AlbumModel::getSection(int row) const
{
    //FIXME depend on sortorder
    QString s = mEntries->at(row)->getTitle();
    return QString(s.toUpper()[0]);
}

void AlbumModel::albumInformationReady(AlbumInformation *info)
{
    if( info == 0 ) {
        return;
    }

    emit requestDBEnter(info);

}

void AlbumModel::albumEntered(QString albumName)
{
    qDebug() << "received new information for album: " << albumName;


    // Search for it in entries
    for ( int i = 0; i < mEntries->length(); i++ ) {
        MpdAlbum *albumObj = mEntries->at(i);
        // Found corresponding albumObj, update coverimage url
        if (albumObj->getTitle() == albumName) {
            emit dataChanged(createIndex(i,0),createIndex(i,0),QVector<int>(1,AlbumImageRole));
        }
    }
}

MpdAlbum *AlbumModel::get(int index)
{
    MpdAlbum *retAlbum = mEntries->at(index);
    QQmlEngine::setObjectOwnership(retAlbum,QQmlEngine::CppOwnership);
    return retAlbum;
}
