#pragma once

#ifndef Q_OS_WINDOWS
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

/*Local includes*/
#include "canSocket.h"

class CanBusModule
{
public:
    virtual void StartupModule();
    virtual void ShutdownModule();

	static bool registerCallback(std::string name, std::function<void(can_frame)> callback);

	//CAN bus interface.
	bool isOpen();
	bool sendFrame(int id, int data[], int size);
    bool sendFrame(can_frame frame);
    bool sendErrorFrame(int id, int data[], int size);

private:
    int threadID;
};


