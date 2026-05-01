#ifndef SYSTEMMONITOR_H
#define SYSTEMMONITOR_H

#include <QObject>
#include <QTimer>

class SystemMonitor : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double ramValue READ ramValue NOTIFY ramValueChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);

    double ramValue() const { return m_ramValue; }

signals:
    void ramValueChanged();

private slots:
    void updateStats();

private:
    double m_ramValue = 0;
    QTimer *m_timer;
};

#endif // SYSTEMMONITOR_H
