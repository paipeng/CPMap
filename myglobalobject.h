#ifndef MYGLOBALOBJECT_H
#define MYGLOBALOBJECT_H

#include <QObject>

class MyGlobalObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int counter READ counter WRITE setCounter NOTIFY counterChanged) // this makes counter available as a QML property


public:
    explicit MyGlobalObject(QObject *parent = nullptr);
    int counter() const;
    void setCounter(int value);

public slots: // slots are public methods available in QML
    void doSomething(const QString &text);
    QString getJson();
signals:
    void counterChanged();
private:
    int m_counter;
};

#endif // MYGLOBALOBJECT_H
