#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QHBoxLayout>
#include <QLabel>
#include <QQuickWidget>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    QHBoxLayout* hBoxLayout = new QHBoxLayout(this);

    QLabel *label = new QLabel(this);
    label->setText("test");

    hBoxLayout->addWidget(label);

    QQuickWidget *view = new QQuickWidget;
    view->setSource(QUrl::fromLocalFile("main.qml"));
    //view->show();
    hBoxLayout->addWidget(view);

    ui->centralwidget->setLayout(hBoxLayout);
}

MainWindow::~MainWindow()
{
    delete ui;
}

