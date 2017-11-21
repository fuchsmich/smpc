#include <mpd/mpdalbum.h>

MpdAlbum::MpdAlbum(QObject *parent) :
    QObject(parent)
{
}

MpdAlbum::MpdAlbum(QObject *parent, QString title, QString artist, QString mbid, QString date) : QObject(parent)
{
    mTitle = title;
    mArtist = artist;
    mMBID = mbid;
    mDate = date;
}

MpdAlbum::MpdAlbum(const MpdAlbum &copyObject,QObject *parent) : QObject(parent)  {
    mTitle = copyObject.mTitle;
    mArtist = copyObject.mArtist;
}

QString MpdAlbum::getTitle() const {
    return mTitle;
}

QString MpdAlbum::getArtist() const {
    return mArtist;
}

QString MpdAlbum::getMBID() const {
    return mMBID;
}

QString MpdAlbum::getDate() const
{
    return mDate;
}

void MpdAlbum::operator =(MpdAlbum &rhs)
{
    mTitle = rhs.mTitle;
    mArtist = rhs.mArtist;
}

bool MpdAlbum::operator ==(MpdAlbum &rhs) const
{
    return mTitle==rhs.mTitle;
}

bool MpdAlbum::operator <(const MpdAlbum &rhs) const
{
    return (mTitle.compare(rhs.mTitle,Qt::CaseInsensitive)<0?1:0);
}

bool MpdAlbum::lessThan(const MpdAlbum *lhs, const MpdAlbum* rhs)
{
    return *lhs<*rhs;
}

bool MpdAlbum::lessThanDate(const MpdAlbum *lhs, const MpdAlbum *rhs)
{
    return (lhs->mDate.compare(rhs->mDate,Qt::CaseInsensitive)<0 ? 1 : 0);
}

// Return first letter as section
QString MpdAlbum::getSection() const
{
    return (mTitle=="" ? "" : QString(mTitle.toUpper()[0]) );
}

