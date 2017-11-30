#include <QGuiApplication>
#include <QQuickView>
#include <QDebug>

#include "src/controller.h"

#include <sailfishapp.h>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setOrganizationName("harbour-smpc");
    app->setApplicationName("harbour-smpc");
//    QString locale = QLocale::system().name();
//    QString translationFile = QString(":translations/harbour-smpc_") + locale;
//    QTranslator translator;
//    translator.load(translationFile);
//    app->installTranslator(&translator);
//    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQuickView *view = SailfishApp::createView();
    view->engine()->addImportPath(SailfishApp::pathTo("qml/").toLocalFile());
    view->engine()->addImportPath(SailfishApp::pathTo("common/qml/").toLocalFile());
    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->setDefaultAlphaBuffer(true);


    qDebug() << view->engine()->importPathList();
    foreach (QString path, view->engine()->importPathList()) {
        qDebug() << path;
    }

    Controller *control = new Controller(view,0);
    view->show();
    return app->exec();
}


