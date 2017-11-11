// Copyright 1998-2017 Epic Games, Inc. All Rights Reserved.

#pragma once

#if Q_OS_ANDROID
/*Linux includes*/
#include <linux/can.h>
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

	/** IModuleInterface implementation */
    virtual void StartupModule();
    virtual void ShutdownModule();

	/** For callbacks that a UObject has sent us we should add them to the vector of callbacks the thread has to deal with. */
	static bool registerCallback(std::string name, std::function<void(can_frame)> callback);

	//CAN bus interface.
	bool isOpen();
	bool sendFrame(int id, int data[], int size);
    bool sendFrame(can_frame frame);
    bool sendErrorFrame(int id, int data[], int size);

private:
    std::thread* thread;
	CANSocket* can;
};


