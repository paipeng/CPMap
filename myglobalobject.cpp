#include "myglobalobject.h"
#include <QDebug>
#include <QFile>

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

QString MyGlobalObject::getJson() {
    //return QString("hello QML from C++");
    QFile mFile(":/json/coordinate.json");
    if(!mFile.open(QFile::ReadOnly | QFile::Text)){
        qDebug() << "could not open file for read";
        return "";
    }
    QTextStream in(&mFile);
    in.setCodec("UTF-8");
    QString mText = in.readAll();
    //qDebug() << mText;
    mFile.close();
    return mText;
}


QString MyGlobalObject::getInfoText() {
    QString infoText;
    infoText.append(tr("person_total"));
    infoText.append(":\n");
    infoText.append(QString::number(20));
    infoText.append("\n");
    infoText.append(tr("idcard_total"));
    infoText.append(":\n");
    infoText.append(QString::number(10));
    infoText.append("\n");
    infoText.append(tr("idcard_person_total"));
    infoText.append(":\n");
    infoText.append(QString::number(4));
    infoText.append("\n");

    infoText.append(tr("person_entry_total"));
    infoText.append(":\n");
    infoText.append(QString::number(4));
    infoText.append("\n");

    infoText.append(tr("person_entry"));
    infoText.append(":\n");
    infoText.append(QString::number(4));
    infoText.append("\n");
    infoText.append(tr("person_exit"));
    infoText.append(":\n");
    infoText.append(QString::number(4));
    infoText.append("\n");


    return infoText;
}

