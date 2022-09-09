#include "myglobalobject.h"
#include <QDebug>

MyGlobalObject::MyGlobalObject(QObject *parent) : QObject(parent), m_counter(0)
{

}


void MyGlobalObject::doSomething(const QString &text) {
    qDebug() << "MyGlobalObject doSomething called with" << text << " count: " << m_counter;
}

int MyGlobalObject::counter() const {
    return m_counter;
}

void MyGlobalObject::setCounter(int value) {
    if(m_counter != value) {
        m_counter = value;
        counterChanged(); // trigger signal of counter change
    }
}
