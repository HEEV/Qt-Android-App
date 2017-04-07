#ifndef NETWORKINTERFACE_H
#define NETWORKINTERFACE_H

//QT includes
#include <QTcpSocket>
#include <QString>
#include <QTextStream>
#include <QJsonObject>
#include <QJsonDocument>

//Again circular dependancies.
class NetworkInterface;

//Local includes
#include <RaceActionManager.h>

class NetworkInterface
{
public:
    NetworkInterface();
    ~NetworkInterface();

    //The RaceActionManager is for the callback that will be used.
    bool connectToServer(RaceActionManager *ram);
    void disconnect();

    bool sendJASON(QJsonObject json);

private:
    QTcpSocket *sock;
    QTextStream *outStream;
    RaceActionManager *raceManager;

    static const QString host;

};

#endif // NETWORKINTERFACE_H
