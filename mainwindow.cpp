#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QHBoxLayout>
#include <QLabel>
#include <QQuickWidget>
#include "myglobalobject.h"
// include qml context, required to add a context property
#include <QQmlContext>
#include "myqmltype.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    QHBoxLayout* hBoxLayout = new QHBoxLayout(this);

    QLabel *label = new QLabel(this);
    label->setText("test");

    //hBoxLayout->addWidget(label);


    MyGlobalObject *myGlobal = new MyGlobalObject(this);
    qmlRegisterType<MyQMLType>("com.yourcompany.xyz", 1, 0, "MyQMLType"); // MyQMLType will be usable with: import com.yourcompany.xyz 1.0
    QQuickWidget *view = new QQuickWidget;
    view->rootContext()->setContextProperty("myGlobalObject", myGlobal);
    view->setSource(QUrl::fromLocalFile("main.qml"));

    myGlobal->doSomething("TEXT FROM C++");
    // register a QML type made with C++

    //view->show();
    hBoxLayout->addWidget(view);

    ui->centralwidget->setLayout(hBoxLayout);
}

MainWindow::~MainWindow()
{
    delete ui;
}

