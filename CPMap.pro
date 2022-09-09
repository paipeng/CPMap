QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

QT += qml quick
QT += quickwidgets



# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    myglobalobject.cpp \
    myqmltype.cpp

HEADERS += \
    mainwindow.h \
    myglobalobject.h \
    myqmltype.h

FORMS += \
    mainwindow.ui

TRANSLATIONS += \
    CPMap_zh_CN.ts
CONFIG += lrelease
CONFIG += embed_translations

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    CPMap.qrc



copydata.commands = $(COPY_DIR) $$PWD/*.qml $$OUT_PWD/CPMap.app/Contents/MacOS
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata
