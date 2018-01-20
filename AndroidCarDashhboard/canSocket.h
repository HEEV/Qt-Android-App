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
#include <vector>

struct can_frame
{
    uint32_t   can_id;  /* 32 bit CAN_ID + EFF/RTR/ERR flags */
    uint8_t    can_dlc; /* frame payload length in byte (0 .. CAN_MAX_DLEN) */
    uint8_t    __pad;   /* padding */
    uint8_t    __res0;  /* reserved / padding */
    uint8_t    __res1;  /* reserved / padding */
    uint8_t    data[8];
};

struct canThread
{
    volatile bool stop;
    int socketHandle;
    bool socketOpen;
    std::string busName;
    std::thread *actualThread;
};

class CANSocket
{
    public:
        static int Init(std::string connectionName);
        static void Run(int threadNumber);
        static void Stop(int threadNumber);

        static bool isOpen(int threadNumber);
        static bool sendFrame(can_frame frame, int threadNumber);

        static std::map<std::string, std::function<void(can_frame)>> callbacks;
        static std::vector<struct canThread*> activeThreads;

    protected:

    private:
        static int socketHandle;
};
