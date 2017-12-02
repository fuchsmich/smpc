COMMON_PATH = $$PWD
#message($$COMMON_PATH)

INCLUDEPATH += $${COMMON_PATH}/src

HEADERS += \
    $${COMMON_PATH}/src/localdb/qmlimageprovider.h \
    $${COMMON_PATH}/src/localdb/lastfmartistprovider.h \
    $${COMMON_PATH}/src/localdb/lastfmalbumprovider.h \
    $${COMMON_PATH}/src/localdb/imagedownloader.h \
    $${COMMON_PATH}/src/localdb/imagedatabase.h \
    $${COMMON_PATH}/src/localdb/databasestatistic.h \
    $${COMMON_PATH}/src/localdb/databasefilljob.h \
    $${COMMON_PATH}/src/localdb/artistinformation.h \
    $${COMMON_PATH}/src/localdb/albuminformation.h \

SOURCES += \
    $${COMMON_PATH}/src/localdb/qmlimageprovider.cpp \
    $${COMMON_PATH}/src/localdb/lastfmartistprovider.cpp \
    $${COMMON_PATH}/src/localdb/lastfmalbumprovider.cpp \
    $${COMMON_PATH}/src/localdb/imagedownloader.cpp \
    $${COMMON_PATH}/src/localdb/imagedatabase.cpp \
    $${COMMON_PATH}/src/localdb/databasefilljob.cpp \
    $${COMMON_PATH}/src/localdb/artistinformation.cpp \
    $${COMMON_PATH}/src/localdb/albuminformation.cpp \


common_qml.files = $${COMMON_PATH}/qml/components/*
# \
#    $${COMMON_PATH}/qml/components/SpeedScroller.js \
#    $${COMMON_PATH}/qml/components/SectionScroller.js \
#    $${COMMON_PATH}/qml/components/ToggleImage.qml \
#    $${COMMON_PATH}/qml/components/SpeedScroller.qml \
#    $${COMMON_PATH}/qml/components/SongDialog.qml \
#    $${COMMON_PATH}/qml/components/SectionScroller.qml \
#    $${COMMON_PATH}/qml/components/ScrollLabel.qml \
#    $${COMMON_PATH}/qml/components/MainGridItem.qml \
#    $${COMMON_PATH}/qml/components/Heading.qml \
#    $${COMMON_PATH}/qml/components/FileDelegate.qml \
#    $${COMMON_PATH}/qml/components/ControlPanel.qml \
#    $${COMMON_PATH}/qml/components/ArtistDelegate.qml \
#    $${COMMON_PATH}/qml/components/AlbumDelegate.qml \
#    $${COMMON_PATH}/qml/components/AlbumShowDelegate.qml \
#    $${COMMON_PATH}/qml/components/ArtistShowDelegate.qml \
#    $${COMMON_PATH}/qml/components/AlbumListDelegate.qml \
#    $${COMMON_PATH}/qml/components/ArtistListDelegate.qml \
#    $${COMMON_PATH}/qml/components/PlaylistSectionDelegate.qml \
#    $${COMMON_PATH}/qml/components/URLInputDialog.qml \
#    $${COMMON_PATH}/qml/components/SavePlaylistDialog.qml \
#    $${COMMON_PATH}/qml/components/DeletePlaylistDialog.qml \
#    $${COMMON_PATH}/qml/components/InfoBanner.qml
common_qml.path = /usr/share/$$TARGET/common/qml/components

INSTALLS += common_qml
DISTFILES += $${COMMON_PATH}/qml/components/* \
    $$PWD/qml/components/qmldir \
    $$PWD/qml/components/AlbumArtistPathView.qml \
    $$PWD/qml/components/AlbumArtistGridView.qml \
    $$PWD/qml/components/AlbumArtistListView.qml \
    $$PWD/qml/components/AlbumArtistListPage.qml \
    $$PWD/qml/components/AlbumArtistListDelegate.qml \
    $$PWD/qml/components/MenuGrid.qml
#    $${COMMON_PATH}/qml/components/qmldir \
#    $${COMMON_PATH}/qml/components/SpeedScroller.js \
#    $${COMMON_PATH}/qml/components/SectionScroller.js \
#    $${COMMON_PATH}/qml/components/ToggleImage.qml \
#    $${COMMON_PATH}/qml/components/SpeedScroller.qml \
#    $${COMMON_PATH}/qml/components/SongDialog.qml \
#    $${COMMON_PATH}/qml/components/SectionScroller.qml \
#    $${COMMON_PATH}/qml/components/ScrollLabel.qml \
#    $${COMMON_PATH}/qml/components/MainGridItem.qml \
#    $${COMMON_PATH}/qml/components/Heading.qml \
#    $${COMMON_PATH}/qml/components/FileDelegate.qml \
#    $${COMMON_PATH}/qml/components/ControlPanel.qml \
#    $${COMMON_PATH}/qml/components/ArtistDelegate.qml \
#    $${COMMON_PATH}/qml/components/AlbumDelegate.qml \
#    $${COMMON_PATH}/qml/components/AlbumShowDelegate.qml \
#    $${COMMON_PATH}/qml/components/ArtistShowDelegate.qml \
#    $${COMMON_PATH}/qml/components/AlbumListDelegate.qml \
#    $${COMMON_PATH}/qml/components/ArtistListDelegate.qml \
#    $${COMMON_PATH}/qml/components/PlaylistSectionDelegate.qml \
#    $${COMMON_PATH}/qml/components/URLInputDialog.qml \
#    $${COMMON_PATH}/qml/components/SavePlaylistDialog.qml \
#    $${COMMON_PATH}/qml/components/DeletePlaylistDialog.qml \
#    $${COMMON_PATH}/qml/components/InfoBanner.qml

