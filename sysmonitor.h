#ifndef SYSMONITOR_H
#define SYSMONITOR_H

#include <QObject>
#include <QTimer>

class SysMonitor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double ramValue READ ramValue WRITE setramValue NOTIFY ramValueChanged FINAL)

public:
    explicit SysMonitor(QObject *parent = nullptr);

    double ramValue() const {return m_ramValue; }

signals:
    void ramValueChanged();

private slots:
    void updateStats();

private:
    double m_ramValue = 0;
    QTimer *m_timer;
};

#endif // SYSMONITOR_H
