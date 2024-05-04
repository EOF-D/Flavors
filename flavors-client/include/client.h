#pragma once

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>

enum class Method { GET, POST, PUT, DELETE };

/**
 * @brief Responsible for handling the API.
 */
class APIClient : public QObject {
  // Q_OBJECT macro is necessary for signals and slots
  Q_OBJECT
  Q_PROPERTY(bool isLoggedIn READ isLoggedIn NOTIFY onLoginChange)

public:
  /**
   * @brief Constructor.
   * @param parent The parent object.
   */
  explicit APIClient(QObject *parent = nullptr) : QObject(parent) {
    // Setting up the network manager.
    _manager = new QNetworkAccessManager(this);

    // Setting up and loading the QML files.
    _engine.rootContext()->setContextProperty("apiClient", this);
    _engine.load(QUrl(QString("qrc:/main.qml")));
    if (_engine.rootObjects().isEmpty()) {
      qDebug() << "Failed to load QML file" << Qt::endl;
      exit(-1);
    }
  }

  /**
   * @brief Logs into the API via username + password.
   * @param username The username.
   * @param password The password.
   */
  Q_INVOKABLE void login(const QString &username, const QString &password);

  /**
   * @brief Sends a regular API request to the web server.
   * @param endpoint The API endpoint.
   * @param method The HTTP method (GET, POST, PUT, DELETE).
   * @param data The request data, if any.
   */
  Q_INVOKABLE void request(const QString &endpoint, Method method,
                           const QJsonObject &data = {});

  /**
   * @brief Sends a GraphQL request to the web server.
   * @param query The GraphQL query.
   */
  Q_INVOKABLE void request(const QString &query);

  /**
   * @brief Checks if the user is logged in.
   * @return True if the user is logged in, false otherwise.
   */
  bool isLoggedIn() const { return _isLoggedIn; }

signals:
  /**
   * @brief Emitted when the user logs in or out.
   */
  void onLoginChange();

  /**
   * @brief Emitted when a response is given.
   * @param response The response.
   */
  void onResponse(const QJsonObject &response);

  /**
   * @brief Emitted when a graphql response is given.
   * @param response The response.
   */
  void onGraphql(const QJsonObject &response);

public slots:
  /**
   * @brief Handles the API response.
   * @param reply The network reply.
   */
  void handleResponse(QNetworkReply *reply);

  /**
   * @brief Handles a graphql response.
   * @param reply The network reply.
   */
  void handleGraphql(QNetworkReply *reply);

private:
  QNetworkAccessManager *_manager; /**< The network manager. */
  QQmlApplicationEngine _engine;   /**< The QML engine. */

  QString _token;           /**< The token. */
  bool _isLoggedIn = false; /**< True if the user is logged in. */
};
