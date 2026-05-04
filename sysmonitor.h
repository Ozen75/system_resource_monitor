#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QTimer>

class SystemMonitor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double ramValue READ ramValue NOTIFY ramValueChanged)
    Q_PROPERTY(double cpuValue READ cpuValue NOTIFY cpuValueChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    double ramValue() const { return m_ramValue; }

signals:
    void ramValueChanged();
    void cpuValueChanged();

private slots:
    void updateStats();

private:
    double m_ramValue = 0;
    QTimer *m_timer;

private:
    // Tambahkan variabel untuk menyimpan data T1 (waktu sebelumnya)
    uint64_t m_prevIdleTime = 0;
    uint64_t m_prevKernelTime = 0;
    uint64_t m_prevUserTime = 0;

    double m_cpuValue = 0; // Tambahkan properti untuk CPU
};

#endif // SYSTEMMONITOR_H
