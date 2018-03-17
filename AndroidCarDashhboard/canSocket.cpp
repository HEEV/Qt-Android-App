#include "canSocket.h"

std::map<std::string ,std::function<void(can_frame)>> CANSocket::callbacks;
std::vector<struct canThread*> CANSocket::activeThreads;


int CANSocket::Init(std::string connectionName)
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
    strcpy(ifr.ifr_name, connectionName.c_str());

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
    //Now we should create the new thread to use.
    canThread *newThreadEntry = new canThread;
    newThreadEntry->stop = false;
    newThreadEntry->socketHandle = socketHandle;
    newThreadEntry->socketOpen = true;
    newThreadEntry->busName = connectionName;
    activeThreads.push_back(newThreadEntry);
    std::thread *tempThreadPointer = new std::thread(CANSocket::Run, activeThreads.size() - 1);
    newThreadEntry->actualThread = tempThreadPointer;
	
    return activeThreads.size() - 1;

#endif
    return -1;
}

void CANSocket::Run(int index)
{
#ifdef Q_OS_ANDROID
    //Allocate some space for received frames and the map iterator.
    can_frame receivedFrame;
    std::map<std::string, std::function<void(can_frame)>>::iterator it;

    while(!activeThreads.at(threadNumber)->stop)
    {
        while(read(activeThreads.at(threadNumber)->socketHandle, &receivedFrame, sizeof(can_frame)) > 0)
        {
            for(it = callbacks.begin(); it != callbacks.end(); it++)
            {
                //Actually call the callback. Finally!!!
                it->second(receivedFrame);
            }
        }
        //If we are not currently receiving a frame we should sleep for a half a second.
        std::this_thread::yeald();
    }
#endif
}

void CANSocket::Stop(int threadNumber)
{
    activeThreads.at(threadNumber)->stop = true;
    activeThreads.at(threadNumber)->actualThread->join();
}

bool CANSocket::isOpen(int threadNumber)
{
    if(threadNumber < activeThreads.size())
    {
        return true;
    }
    else
    {
        return false;
    }
}

bool CANSocket::sendFrame(can_frame frame, int threadNumber)
{
#ifdef Q_OS_ANDROID
    if(isOpen(threadNumber))
    {
        int retval;
        retval = write(activeThreads.at(threadNumber)->socketHandle, frame, sizeof(struct can_frame));
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
