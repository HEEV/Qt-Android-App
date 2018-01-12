#include "canSocket.h"

std::map<std::string ,std::function<void(can_frame)>> CANSocket::callbacks;
volatile bool CANSocket::closeThread = false;

CANSocket::CANSocket()
{
    CANSocket("can0");
}

CANSocket::CANSocket(std::string connectionName)
{
    socketOpen = false;
    busName = connectionName;
}

CANSocket::~CANSocket()
{
}

bool CANSocket::Init()
{
    #ifdef Q_OS_ANDROID
    //Now we should set up the socket connection.
    struct ifreq ifr;
    struct sockaddr_can addr;

    socketHandle = socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if(socketHandle < 0)
    {
        return false;
    }
    
    //Select the type of CAN port we want to use. Basic non-extended is fine.
    addr.can_family = AF_CAN;
    strcpy(ifr.ifr_name, busName.c_str());

    //check if the socket is valid.
    if(ioctl(socketHandle, SIOCGIFINDEX, &ifr) < 0)
    {
        return false;
    }
    addr.can_ifindex = ifr.ifr_ifindex;

    //Now set up the socket and bind to it.
    fcntl(socketHandle, F_SETFL, O_NONBLOCK);
    if(bind(socketHandle, (struct sockaddr *)&addr, sizeof(addr)) < 0)
    {
        return false;
    }
    //If we made it here the socket is set up and ready to go.
    socketOpen = true;
	
	#endif
	
	
    return true;
}

void CANSocket::Run()
{
    #ifdef Q_OS_ANDROID
    //Allocate some space for received frames and the map iterator.
    can_frame receivedFrame;
    std::map<std::string, std::function<void(can_frame)>>::iterator it;

    while(!closeThread)
    {
        while(read(socketHandle, &receivedFrame, sizeof(can_frame)) > 0)
        {
            for(it = callbacks.begin(); it != callbacks.end(); it++)
            {
                //Actually call the callback. Finally!!!
                it->second(receivedFrame);
            }
        }
        //If we are not currently receiving a frame we should sleep for a half a second.
        std::this_thread::sleep_for(0.1);
    }
	#endif
}

void CANSocket::Stop()
{
    CANSocket::closeThread = true;
}

bool CANSocket::isOpen() {
    return socketOpen;
}

bool CANSocket::sendFrame(can_frame frame)
{
    #ifdef Q_OS_ANDROID
    if (socketOpen)
    {
        int retval;
        retval = write(socketHandle, frame, sizeof(struct can_frame));
        if (retval != sizeof(struct can_frame))
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    #endif
    return false;
}
