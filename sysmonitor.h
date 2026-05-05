#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QTimer>
#include <cstdint>
#include <windows.h>

class SystemMonitor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double ramValue READ ramValue NOTIFY ramValueChanged)
    Q_PROPERTY(double cpuValue READ cpuValue NOTIFY cpuValueChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    double ramValue() const { return m_ramValue; }
    double cpuValue() const { return m_cpuValue; }

signals:
    void ramValueChanged();
    void cpuValueChanged();

private slots:
    void updateStats();

private:
    uint64_t fileTimeToUint64(const FILETIME& ft);
    double m_ramValue = 0;
    double m_cpuValue = 0;
    QTimer *m_timer;

    // Tambahkan variabel untuk menyimpan data T1 (waktu sebelumnya)
    uint64_t m_prevIdleTime = 0;
    uint64_t m_prevKernelTime = 0;
    uint64_t m_prevUserTime = 0;

};

#endif // SYSTEMMONITOR_H
