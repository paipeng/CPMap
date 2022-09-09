#ifndef MYQMLTYPE_H
#define MYQMLTYPE_H

#include <QObject>

class MyQMLType : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged) // this makes message available as a QML property

public:
    explicit MyQMLType(QObject *parent = nullptr);

public slots: // slots are public methods available in QML
int increment(int value);

signals:
void messageChanged();

public:
    QString message() const;
    void setMessage(const QString& value);

private:
    QString m_message;
};

#endif // MYQMLTYPE_H
