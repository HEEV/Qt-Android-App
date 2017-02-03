#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <UIRaceDataset.h>
//#include <usb_interface.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlEngine engine;
    UIRaceDataset raceDataset;
    // Placeholder temporary remove this later this is terrible blah blah blah
    raceDataset.setProjectedProgress(0.95);

    //usb_interface usb;

    engine.rootContext()->setContextProperty("UIRaceDataset", &raceDataset);

    QQmlComponent component(&engine, QUrl(QLatin1String("qrc:/main.qml")));
    component.create();

    const int returnval = app.exec();

    return returnval;
}
