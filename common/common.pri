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


common_qml.files = $${COMMON_PATH}/qml/*
common_qml.path = /usr/share/$$TARGET/common/qml
INSTALLS += common_qml
DISTFILES += $${COMMON_PATH}/qml/components/*
DISTFILES += $${COMMON_PATH}/qml/pages/*
DISTFILES += $${COMMON_PATH}/qml/pages/_private/*


#pages_qml.files = $${COMMON_PATH}/qml/pages/*
#pages_qml.path = /usr/share/$$TARGET/common/qml/pages
#INSTALLS += pages_qml
#DISTFILES += $${COMMON_PATH}/qml/pages/*
