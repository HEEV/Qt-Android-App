#include <QGuiApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>
#include <UIRaceDataset.h>
#include <CANInterface.h>
#include <DataProcessor.h>
#include <Logger.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlEngine engine;
    UIRaceDataset *raceDataset = new UIRaceDataset();
    // Placeholder temporary remove this later this is terrible blah blah blah
    raceDataset->setProjectedProgress(0.95);
    raceDataset->setGroundSpeed(38.0);


    //Make a DataProcessor.
    DataProcessor *dataProcessor = new DataProcessor(raceDataset, 69.115 /*this number is just a guess*/);

    //Make a instance of CANInterface.
    CANInterface *interface = new CANInterface(dataProcessor);

    // Make a logging object
    Logger *logger = new Logger("./logFile.txt");
    logger->println("Hello World");
    logger->println("This is a test");

    engine.rootContext()->setContextProperty("UIRaceDataset", raceDataset);
    engine.rootContext()->setContextProperty("Logger", logger);

    QQmlComponent component(&engine, QUrl(QLatin1String("qrc:/main.qml")));
    component.create();

    const int returnval = app.exec();

    return returnval;
}
