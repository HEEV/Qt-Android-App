#include "NetworkInterface.h"

const QString NetworkInterface::host = "jacob.cedarville.edu";

NetworkInterface::NetworkInterface()
{
    //Default the socket to a null value.
    sock = nullptr;
    raceManager = nullptr;
}


bool NetworkInterface::connectToServer(RaceActionManager *ram)
{
    if(sock == nullptr)
    {
        raceManager = ram;
        sock = new QTcpSocket();
        sock->connectToHost(host, 3306);
        if(sock->state() == QTcpSocket::ConnectedState ||
           sock->state() == QTcpSocket::ConnectingState ||
           sock->state() == QTcpSocket::BoundState)
        {
            return true;
        }
        return false;
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

NetworkInterface::~NetworkInterface()
{
    raceManager = nullptr;
}
