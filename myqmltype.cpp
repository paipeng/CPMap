#include "myqmltype.h"

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
