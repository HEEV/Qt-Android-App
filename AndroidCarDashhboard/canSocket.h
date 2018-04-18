#pragma once

/*C++ includes*/
#include <string>
#include <cstring>
#include <iostream>
#include <functional>
#include <iomanip>
#include <map>
#include <thread>
#include <vector>

/*QT Includes*/
#include <QtGlobal>

#if defined(Q_OS_LINUX) || defined(Q_OS_ANDROID)
/*Linux includes*/
#include <linux/can.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <netinet/in.h>
#include <unistd.h>
#include <fcntl.h>
#endif




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
#if defined(Q_OS_ANDROID) || defined(Q_OS_LINUX)
        static bool sendFrame(can_frame frame, int threadNumber);

        static std::map<std::string, std::function<void(can_frame)>> callbacks;
        static std::vector<struct canThread*> activeThreads;
#endif
    protected:

    private:
        static int socketHandle;
};
