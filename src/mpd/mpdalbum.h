#ifndef MPDALBUM_H
#define MPDALBUM_H

#include <QObject>

class MpdAlbum : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ getTitle CONSTANT)
    Q_PROPERTY(QString sectionprop READ getSection CONSTANT)
    Q_PROPERTY(QString mbid READ getMBID CONSTANT)
    Q_PROPERTY(QString artist READ getArtist CONSTANT)
    Q_PROPERTY(QString date READ getDate CONSTANT)
    Q_PROPERTY(QString section READ getSection CONSTANT)
public:
    explicit MpdAlbum(QObject *parent = 0);

    MpdAlbum(QObject *parent, QString title, QString artist = "", QString date = "", QString mbid = "", QString section = "");

    MpdAlbum(const MpdAlbum &copyObject, QObject *parent = 0);

    QString getTitle() const;
    QString getSection() const;
    QString getArtist() const;
    QString getMBID() const;
    QString getDate() const;

    bool operator<(const MpdAlbum& rhs) const;
    bool operator==(MpdAlbum & rhs) const ;
    void operator=(MpdAlbum &rhs);

    static bool lessThan(const MpdAlbum *lhs, const MpdAlbum* rhs);
    static bool lessThanDate(const MpdAlbum *lhs, const MpdAlbum *rhs);

private:
    QString mTitle;
    QString mArtist;
    QString mMBID;
    QString mDate;
    QString mSection;

//signals:
    // Dummy signal, so qml shuts up
    //void changed();

public slots:

};

#endif // MPDALBUM_H
