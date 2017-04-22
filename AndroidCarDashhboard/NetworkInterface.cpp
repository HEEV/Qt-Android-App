#include "NetworkInterface.h"

const QString NetworkInterface::host = "jacob.cedarville.edu";
const int NetworkInterface::port = 3306;
const int NetworkInterface::initialConnectionAttemptInterval = 2000;
const int NetworkInterface::reconnectAttemptInterval = 2000;

const string NetworkInterface::logPrefix = "NETWORK_INTERFACE: ";

NetworkInterface::NetworkInterface(Logger *log)
{
    //Default the socket to a null value.
    sock = nullptr;
    reconnectInProgress = false;
    raceManager = nullptr;
    this->log = log;


}

bool NetworkInterface::connectToServer(RaceActionManager *ram)
{
    if(sock == nullptr)
    {
        raceManager = ram;
        sock = new QTcpSocket();
        sock->connectToHost(host, port);

        // Hook up event handlers for connection errors and successful connections.
        connect(sock, SIGNAL(connected()), this, SLOT(handleOnConnected()));
        connect(sock, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(handleConnectionError(QAbstractSocket::SocketError)));

        if (sock->waitForConnected(initialConnectionAttemptInterval)) {
            return true;
        } else {
            return false;
        }
    }
    return false;
}


void NetworkInterface::disconnect()
{
    if(sock != nullptr)
    {
        sock->disconnectFromHost();
        delete sock;
    }
}

bool NetworkInterface::sendJASON(QJsonObject json)
{
    QJsonDocument jDoc = QJsonDocument(json);
    int written = sock->write(jDoc.toJson());
    if(written > 0)
    {
        return true;
    }
    return false;
}

/**
 * @brief Prints to the log a message saying that we are connected to the server.
 */
void NetworkInterface::handleOnConnected()
{
    log->println(logPrefix + "Connected to server.");
}

/**
 * @brief Handler for the QTcpSocket's error() signal. Queues an attempt to reconnect to the server if an attempt is not already being made.
 * @param error
 */
void NetworkInterface::handleConnectionError(QAbstractSocket::SocketError error)
{
    if (error == QAbstractSocket::RemoteHostClosedError || error == QAbstractSocket::ConnectionRefusedError)
    {
        if (!reconnectInProgress)
        {
            issueReconnectAttempt();
        }
    } else
    {
        log->println(logPrefix + "Unhandled error type.");
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
    log->println(logPrefix + "Attempting to reconnect to server.");

    // QTcpSocket's connectToHost() rather than our own connectToServer() so
    // that we don't have to destroy and re-allocate sock
    sock->connectToHost(host, port);
    // This variable prevents us from issuing multiple reconnection attempts at once.
    reconnectInProgress = false;
}

NetworkInterface::~NetworkInterface()
{
    raceManager = nullptr;
}
