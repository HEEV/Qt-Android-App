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
#include <map>
#include <thread>

class CANSocket
{
    public:
        CANSocket();
        CANSocket(std::string connectionName);
        ~CANSocket();

        // Begin FRunnable interface.
	    virtual bool Init();
        virtual unsigned int Run();
	    virtual void Stop();
	    // End FRunnable interface

        bool isOpen();
        bool sendFrame(can_frame frame);

        static std::map<std::string ,std::function<void(can_frame)>> callbacks;

    protected:

    private:
        int socketHandle;
        bool socketOpen;
        volatile bool closeThread;
        std::string busName;
        
};
