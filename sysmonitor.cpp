#include "sysmonitor.h"
#include <windows.h>

SystemMonitor::SystemMonitor(QObject *parent) : QObject(parent)
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &SystemMonitor::updateStats);
    m_timer->start(1000);

    updateStats();
}

uint64_t SystemMonitor::fileTimeToUint64(const FILETIME& ft) {
    return (static_cast<uint64_t>(ft.dwHighDateTime) << 32) | ft.dwLowDateTime;
}

void SystemMonitor::updateStats()
{
    // Mengambil data CPU
    FILETIME idleTime, kernelTime, userTime;
    if (GetSystemTimes(&idleTime, &kernelTime, &userTime)) {

        uint64_t currentIdle = fileTimeToUint64(idleTime);
        uint64_t currentKernel = fileTimeToUint64(kernelTime);
        uint64_t currentUser = fileTimeToUint64(userTime);

        // Hitung selisih antara T2 (sekarang) dan T1 (sebelumnya)
        uint64_t idleDiff = currentIdle - m_prevIdleTime;
        uint64_t kernelDiff = currentKernel - m_prevKernelTime;
        uint64_t userDiff = currentUser - m_prevUserTime;
        uint64_t totalDiff = kernelDiff + userDiff;

        if (totalDiff > 0) {
            // Rumus: 100% - (Waktu Idle / Total Waktu)
            m_cpuValue = 100.0 * (1.0 - static_cast<double>(idleDiff) / totalDiff);
            emit cpuValueChanged();
        }

        // Simpan data sekarang untuk perbandingan di detik berikutnya (T1 berikutnya)
        m_prevIdleTime = currentIdle;
        m_prevKernelTime = currentKernel;
        m_prevUserTime = currentUser;
    }
    // Mengambil data RAM
    MEMORYSTATUSEX memInfo;
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);

    // dwMemoryLoad adalah persentase RAM yang terpakai
    double currentRam = static_cast<double>(memInfo.dwMemoryLoad);

    if (m_ramValue != currentRam) {
        m_ramValue = currentRam;
        emit ramValueChanged(); // Kirim sinyal ke QML agar UI update
    }

    // Mengambil data traffic/bandwith internet
    ULONG bufferSize = 0;
    // Mengambil tabel semua interface jaringan (WiFi, Ethernet, dll)
    GetIfTable(nullptr, &bufferSize, FALSE);
    MIB_IFTABLE* pIfTable = (MIB_IFTABLE*)malloc(bufferSize);

    if (GetIfTable(pIfTable, &bufferSize, FALSE) == NO_ERROR) {
        long long currentInBytes = 0;
        long long currentOutBytes = 0;

        for (UINT i = 0; i < pIfTable->dwNumEntries; i++) {
            // Kita hanya menghitung interface yang aktif dan bukan loopback
            if (pIfTable->table[i].dwType != IF_TYPE_SOFTWARE_LOOPBACK) {
                currentInBytes += pIfTable->table[i].dwInOctets;
                currentOutBytes += pIfTable->table[i].dwOutOctets;
            }
        }

        // Hitung selisih (Delta) untuk mendapatkan Byte per Second (Bps)
        double downSpeedBps = currentInBytes - m_prevInBytes;
        double upSpeedBps = currentOutBytes - m_prevOutBytes;

        // Konversi ke Mbps (Megabit per second)
        // (Byte * 8 bit) / 1.000.000
        m_downloadSpeed = (downSpeedBps * 8) / 1000000.0;
        m_uploadSpeed = (upSpeedBps * 8) / 1000000.0;

        // Simpan untuk perhitungan detik berikutnya
        m_prevInBytes = currentInBytes;
        m_prevOutBytes = currentOutBytes;

        emit netValueChanged();
    }
    free(pIfTable);
}

