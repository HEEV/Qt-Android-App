#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <UIRaceDataset.h>
#include <CANInterface.h>
#include <DataProcessor.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlEngine engine;
    UIRaceDataset raceDataset;
    // Placeholder temporary remove this later this is terrible blah blah blah
    raceDataset.setProjectedProgress(0.95);

    //Make a instance of CANInterface.
    CANInterface interface = new CANInterface();

    //Make a DataProcessor.
    DataProcessor dataProcessor = new DataProcessor();

    engine.rootContext()->setContextProperty("UIRaceDataset", &raceDataset);

    QQmlComponent component(&engine, QUrl(QLatin1String("qrc:/main.qml")));
    component.create();

    const int returnval = app.exec();

    return returnval;
}
