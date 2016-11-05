#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <uiracedataset.h>
#include <usb_interface.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlEngine engine;
    UIRaceDataSet raceDataSet;
    // Placeholder temporary remove this later this is terrible blah blah blah
    raceDataSet.setProjectedProgress(0.95);

    usb_interface usb;

    engine.rootContext()->setContextProperty("UIRaceDataSet", &raceDataSet);

    QQmlComponent component(&engine, QUrl(QLatin1String("qrc:/main.qml")));
    component.create();

    const int returnval = app.exec();

    return returnval;
}
