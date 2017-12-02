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
#include <map>
#include <thread>

struct can_frame {
    uint32_t   can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
    uint8_t    can_dlc; /* frame payload length in byte (0 .. CAN_MAX_DLEN) */
    uint8_t    __pad;   /* padding */
    uint8_t    __res0;  /* reserved / padding */
    uint8_t    __res1;  /* reserved / padding */
    uint8_t    data[8];
};

class CANSocket
{
    public:
        CANSocket();
        CANSocket(std::string connectionName);
        ~CANSocket();

        // Begin FRunnable interface.
        bool Init();
        static void Run();
        void Stop();
	    // End FRunnable interface

        bool isOpen();
        bool sendFrame(can_frame frame);

        static std::map<std::string ,std::function<void(can_frame)>> callbacks;

    protected:

    private:
        int socketHandle;
        bool socketOpen;
        volatile static bool closeThread;
        std::string busName;
        
};
