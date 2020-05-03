#include <QGuiApplication>
#include <QQuickView>
#include <QDebug>

#include "src/controller.h"

#include <sailfishapp.h>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QProcess appinfo;
    QString appversion;
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    app->setOrganizationName("harbour-smpc");
    app->setApplicationName("harbour-smpc");
    // QString locale = QLocale::system().name();
    // QString translationFile = QString(":translations/harbour-smpc_") + locale;
    // QTranslator translator;
    // translator.load(translationFile);
    // app->installTranslator(&translator);
//    QScopedPointer<QQuickView> view(SailfishApp::createView());
    appinfo.start("/bin/rpm", QStringList() << "-qa"
                                            << "--queryformat"
                                            << "%{version}-%{RELEASE}"
                                            << "harbour-smpc");
    appinfo.waitForFinished(-1);
    if (appinfo.bytesAvailable() > 0) {
        appversion = appinfo.readAll();
    }
    QLocale::setDefault(QLocale::c());
    QQuickView *view = SailfishApp::createView();
    view->engine()->addImportPath("/usr/share/harbour-smpc/qml/");
    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->setDefaultAlphaBuffer(true);
    view->rootContext()->setContextProperty("version", appversion);

    foreach (QString path, view->engine()->importPathList()) {
        qDebug() << path;
    }

    Controller *control = ControllerSglt::getInstance(); //new Controller(view,0);
    control->init(view);
    view->show();
    return app->exec();
}
