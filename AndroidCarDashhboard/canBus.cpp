// Copyright 1998-2017 Epic Games, Inc. All Rights Reserved.

#include "canBus.h"

/*
* This code will execute after your module is loaded into memory; the exact timing is specified in the .uplugin file per-module
*/
void CanBusModule::StartupModule()
{
    can = new CANSocket("can0");
	//Now we should try to connect to the CAN bus.
    can->Init();
    thread = new std::thread(can->Run());
}

/* This function may be called during shutdown to clean up your module.  For modules that support dynamic reloading,
* we call this function before unloading the module.
*/
void CanBusModule::ShutdownModule()
{
    thread->Stop();
    thread->join();
}

/** For callbacks that a UObject has sent us we should add them to the vector of callbacks the thread has to deal with. */
bool CanBusModule::registerCallback(std::string name, std::function<void(can_frame)> callback)
{
	CANSocket::callbacks.insert(std::pair<std::string, std::function<void(can_frame)>>(name, callback));
	return true;
}

bool CanBusModule::isOpen()
{
	return true;
}

bool CanBusModule::sendFrame(int id, int data[], int size)
{
    if (size > 8) {
        //You're an idiot
        return false;
    }

    can_frame cf;

    cf.can_id = id;
    cf.can_dlc = size;
    for (int x = 0; x < size ; x++) {
        cf.data[x] = data[x];
    }

    return sendFrame(cf);
}

bool CanBusModule::sendFrame(can_frame frame)
{
    return can->sendFrame(frame);
}

bool CanBusModule::sendErrorFrame(int id, int data[], int size)
{
	return true;
}
