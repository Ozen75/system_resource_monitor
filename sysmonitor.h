#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QTimer>
#include <cstdint>
#include <windows.h>
#include <winsock2.h>
#include <iphlpapi.h>

#pragma comment(lib, "iphlpapi.lib")

class SystemMonitor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double ramValue READ ramValue NOTIFY ramValueChanged)
    Q_PROPERTY(double cpuValue READ cpuValue NOTIFY cpuValueChanged)
    Q_PROPERTY(double netValue READ netValue NOTIFY netValueChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    double ramValue() const { return m_ramValue; }
    double cpuValue() const { return m_cpuValue; }
    double netValue() const { return m_netValue; }

signals:
    void ramValueChanged();
    void cpuValueChanged();
    void netValueChanged();

private slots:
    void updateStats();

private:
    uint64_t fileTimeToUint64(const FILETIME& ft);
    double m_ramValue = 0;
    double m_cpuValue = 0;
    double m_netValue = 0;
    QTimer *m_timer;

    // Tambahkan variabel untuk menyimpan data T1 (waktu sebelumnya)
    uint64_t m_prevIdleTime = 0;
    uint64_t m_prevKernelTime = 0;
    uint64_t m_prevUserTime = 0;

    double m_prevInBytes = 0;
    double m_prevOutBytes = 0;
    double m_downloadSpeed = 0;
    double m_uploadSpeed = 0;
};

#endif // SYSTEMMONITOR_H
