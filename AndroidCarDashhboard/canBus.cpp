#include "canBus.h"

void CanBusModule::StartupModule()
{
    threadID = CANSocket::Init("can0");
}

void CanBusModule::ShutdownModule()
{
    CANSocket::Stop(threadID);
}

bool CanBusModule::registerCallback(std::string name, std::function<void(can_frame)> callback)
{
	CANSocket::callbacks.insert(std::pair<std::string, std::function<void(can_frame)>>(name, callback));
	return true;
}

bool CanBusModule::isOpen()
{
    return CANSocket::isOpen(threadID);
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
    return CANSocket::sendFrame(frame, threadID);
}

bool CanBusModule::sendErrorFrame(int id, int data[], int size)
{
	return true;
}
