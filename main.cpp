#include <QGuiApplication>
#include <QQuickView>
#include <QDebug>

#include "src/controller.h"
#include "src/resourcehandler.h"

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

    ResourceHandler *resourceHandler = new ResourceHandler();

    QLocale::setDefault(QLocale::c());
    QQuickView *view = SailfishApp::createView();
    view->engine()->addImportPath("/usr/share/harbour-smpc/qml/");
    view->setSource(SailfishApp::pathTo("qml/main.qml"));
    view->setDefaultAlphaBuffer(true);
    view->rootContext()->setContextProperty("version", appversion);
    view->rootContext()->setContextProperty(QLatin1String("resourceHandler"), resourceHandler);

    foreach (QString path, view->engine()->importPathList()) {
        qDebug() << path;
    }

    Controller *control = new Controller(view, nullptr);
    view->rootContext()->setContextProperty("ctl", control);
    view->show();
    return app->exec();
}
