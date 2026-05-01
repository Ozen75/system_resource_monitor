#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "sysmonitor.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    SystemMonitor monitor;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("backend", &monitor);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("system_resource_monitor", "Main");

    return QCoreApplication::exec();
}
