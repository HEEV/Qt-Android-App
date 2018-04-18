#pragma once

#ifdef Q_OS_ANDROID
/*Linux includes*/
#include <sys/ioctl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#endif

/*C++ includes*/
#include <string>
#include <cstring>
#include <iostream>
#include <functional>
#include <iomanip>
#include <thread>
#include <map>

/*QT Includes*/
#include <QtGlobal>

/*Local includes*/
#include "canSocket.h"

class CanBusModule
{
public:
    virtual void StartupModule();
    virtual void ShutdownModule();
#if defined(Q_OS_ANDROID) || defined(Q_OS_LINUX)
    static bool registerCallback(std::string name, std::function<void(can_frame)> callback);
#endif
    //CAN bus interface.
    bool isOpen();
    bool sendFrame(int id, int data[], int size);
#if defined(Q_OS_ANDROID) || defined(Q_OS_LINUX)
    bool sendFrame(can_frame frame);
#endif
    bool sendErrorFrame(int id, int data[], int size);

private:
    int threadID;
};


