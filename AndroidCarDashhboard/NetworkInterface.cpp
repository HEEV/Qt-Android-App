#include "NetworkInterface.h"

const QString NetworkInterface::host = "jacob.cedarville.edu"; 
//This port is a placeholder please talk to a team leader about what it should actually be.
const int NetworkInterface::port = 64738;
const int NetworkInterface::reconnectAttemptInterval = 2000;

const string NetworkInterface::logPrefix = "NETWORK_INTERFACE: ";

NetworkInterface::NetworkInterface(Logger *log)
{
    //Get MAC address for ID.
    for(auto interface: QNetworkInterface::allInterfaces())
    {
        if(interface.name() == QLatin1String("wlan0"))
        {
            macAddress = interface.hardwareAddress();
            log->println( + " MAC address: " + macAddress.toStdString() + "\n");
        }
    }

    reconnectInProgress = false;
    raceManager = nullptr;
    this->log = log;

    sock = new QTcpSocket();
    // Hook up event handlers for connection errors and successful connections.
    connect(sock, SIGNAL(connected()), this, SLOT(handleOnConnected()));
    connect(sock, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(handleConnectionError(QAbstractSocket::SocketError)));
    connect(sock, SIGNAL(readyRead()), this, SLOT(handleReceiveData()));
}

bool NetworkInterface::connectToServer(RaceActionManager *ram)
{
    shouldTryToReconnect = true;
    if(!isConnected())
    {
        raceManager = ram;

        sock->connectToHost(host, port);

        return true;
    }
    return false;
}

bool NetworkInterface::isConnected()
{
    if (sock == nullptr)
    {
        return false;
    }
    else
    {
        return (sock->state() == QAbstractSocket::ConnectedState);
    }
}

void NetworkInterface::disconnect()
{
    shouldTryToReconnect = false;
    if(isConnected())
    {
        sock->write("quit\n");
        sock->disconnectFromHost();
    }
}

bool NetworkInterface::sendJSON(QJsonObject json)
{
    QJsonDocument doc(json);
    QString strJson = doc.toJson();
    strJson = strJson.remove(QRegExp("[\\n\\t\\r]"));
    //int length = strJson.length();
    QString packet = strJson + "\n";

    int written = sock->write(packet.toLocal8Bit());
    log->println(packet);
    if(written > 0)
    {
        return true;
    }
    return false;
}

/**
 * @brief Event handler that fires when new data arrives from the server.
 */
void NetworkInterface::handleReceiveData()
{
        log->println((QString)"Recieved Packet\n");
        QByteArray data;
        data = sock->readAll();
        /*while(sock->canReadLine())
        {
            data += sock->readLine();
        }*/

        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
        QJsonObject jsonObj = jsonDoc.object();
        log->println("Got: " + data + "\n");
        if(jsonObj.contains("NextRunNum"))
        {
            raceManager->setRunNum(jsonObj.value("NextRunNum").toInt());
        }
}

/**
 * @brief Prints to the log a message saying that we are connected to the server.
 */
void NetworkInterface::handleOnConnected()
{
    inStream = new QTextStream(sock);
    log->println(logPrefix + "Connected to server.");
}

/**
 * @brief Handler for the QTcpSocket's error() signal. Queues an attempt to reconnect to the server if an attempt is not already being made.
 * @param error
 */
void NetworkInterface::handleConnectionError(QAbstractSocket::SocketError error)
{
    if (shouldTryToReconnect && !reconnectInProgress)
    {
        issueReconnectAttempt();
    }
}

/**
 * @brief Waits for as many milliseconds as specified by NetworkInterface::reconnectAttemptInterval, then
 * issues an attempt to reconnect to the server.
 */
void NetworkInterface::issueReconnectAttempt()
{
    static string timeout = QString::number(reconnectAttemptInterval / 1000).toStdString();

    log->println(logPrefix + "Waiting " + timeout + "s to reconnect...");

    // This variable prevents us from issuing multiple reconnection attempts at once.
    reconnectInProgress = true;
    QTimer::singleShot(reconnectAttemptInterval, this,  SLOT(attemptToReconnect()));
}

/**
 * @brief Attempts to connect to the server.
 */
void NetworkInterface::attemptToReconnect()
{
    if (shouldTryToReconnect) // This value should be false if the race has stopped
    {
        log->println(logPrefix + "Attempting to reconnect to server.");

        // QTcpSocket's connectToHost() rather than our own connectToServer() so
        // that we don't have to destroy and re-allocate sock
        sock->connectToHost(host, port);
        // This variable prevents us from issuing multiple reconnection attempts at once.
        reconnectInProgress = false;
    }
}

NetworkInterface::~NetworkInterface()
{
    raceManager = nullptr;
    delete sock;
    delete inStream;
}
