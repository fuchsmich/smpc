#ifndef SERVERINFO_H
#define SERVERINFO_H

#include "mpdcommon.h"

class ServerInfo
{
public:
    ServerInfo();

    void setVersion(MPD_version_t version);
    void setIdleSupported(bool idle);
    void setAlbumartSupported(bool value);
    void setListGroupSupported(bool groupSupported);
    void setListMultiGroupSupported(bool multiGroupSupported);
    void setListGroupFormatOld(bool value);
    void setListFilterSupported(bool filter);
    void setMBIDTagsSupported(bool MBIDSupported);

    MPD_version_t *getVersion();
    bool getIdleSupported();
    bool getAlbumartSupported();
    bool getListGroupSupported();
    bool getListMultiGroupSupported();
    bool getListGroupFormatOld();
    bool getListFilterSupported();
    bool getMBIDTagsSupported();


private:
    /**
     * @brief pVersion Version of the connected MPD server
     */
    MPD_version_t pVersion;

    /**
     * @brief pIdleSupported if IDLE command is supported on server
     */
    bool pIdleSupported;

    /**
     * @brief pAlbumartSupported if albumart command is supported on server
     */
    bool pAlbumartSupported;

    /**
     * @brief pListGroupSupported True if grouping is available on queries
     */
    bool pListGroupSupported;

    /**
     * @brief pListMultiGroupSupported True if multiple grouping is available on queries
     */
    bool pListMultiGroupSupported;

    /**
     * @brief pListGroupFormatOld True for old format of grouped list (v < 0.21.x)
     */
    bool pListGroupFormatOld;

    /**
     * @brief pListFilterSupported True if filtering lists is possible (Artist albums)
     */
    bool pListFilterSupported;

    /**
     * @brief pMBIDTagsSupported True if MusicBrainz IDs are available as tags
     */
    bool pMBIDTagsSupported;
};

#endif // SERVERINFO_H
