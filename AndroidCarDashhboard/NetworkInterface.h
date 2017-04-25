#ifndef NETWORKINTERFACE_H
#define NETWORKINTERFACE_H

//QT includes
#include <QTcpSocket>
#include <QString>
#include <QTextStream>
#include <QJsonObject>
#include <QJsonDocument>
#include "Logger.h"

//Again circular dependancies.
class NetworkInterface;

//Local includes
#include <RaceActionManager.h>

class NetworkInterface : public QObject
{
    Q_OBJECT

public:
    NetworkInterface(Logger *log);
    ~NetworkInterface();

    //The RaceActionManager is for the callback that will be used.
    bool connectToServer(RaceActionManager *ram);
    void disconnect();
    bool isConnected();

    bool sendJASON(QJsonObject json);

private:
    QTcpSocket *sock;
    QTextStream *outStream;
    QTextStream *inStream;
    RaceActionManager *raceManager;

    static const QString host;
    static const int port;
    void issueReconnectAttempt();
    // Prevents us from issuing more than one reconnection attempt at a time
    bool reconnectInProgress;
    static const int reconnectAttemptInterval;
    static const int initialConnectionAttemptInterval;

    Logger *log;
    static const string logPrefix;

private slots:
    void handleOnConnected();
    void handleConnectionError(QAbstractSocket::SocketError error);
    void attemptToReconnect();

    void handleReceiveData();

};

#endif // NETWORKINTERFACE_H
