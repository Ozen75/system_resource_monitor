#include "sysmonitor.h"
#include <windows.h>

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent)
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &SystemMonitor::updateStats);
    m_timer->start(1000);

    updateStats();
}

void SystemMonitor::updateStats()
{
    // Mengambil data RAM menggunakan Windows API
    MEMORYSTATUSEX memInfo;
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);

    // dwMemoryLoad adalah persentase RAM yang terpakai
    double currentRam = static_cast<double>(memInfo.dwMemoryLoad);

    if (m_ramValue != currentRam) {
        m_ramValue = currentRam;
        emit ramValueChanged(); // Kirim sinyal ke QML agar UI update
    }
}