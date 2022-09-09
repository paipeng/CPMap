#include "myqmltype.h"
#include <QDebug>

MyQMLType::MyQMLType(QObject *parent) : QObject(parent), m_message("")
{

}


int MyQMLType::increment(int value) {
    return value + 1;
}

QString MyQMLType::message() const {
    return m_message;
}

void MyQMLType::setMessage(const QString& value) {
    if(m_message != value) {
        m_message = value;
        messageChanged(); // trigger signal of property change
    }
}

void MyQMLType::startCppTask() {
    qDebug() << "startCppTask";
    this->doCppTask();
}

void MyQMLType::doCppTask() {
    // NOTE: you can do calculations here in another thread, this may be used to perform
    // cpu-intense operations for e.g. AI (artificial itelligence), Machine Learning or similar purposes
    // When the work is done, we can trigger the cppTaskFinished signal and react anyhwhere in C++ or QML
    cppTaskFinished();
}
