#include "client.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);
  APIClient client;

  return app.exec();
}
