#include "client.h"

// clang-format off
void APIClient::login(const QString &username, const QString &password) {
  _engine.rootContext()->setContextProperty("username", username);
  request("login", Method::POST, {{"username", username}, {"password", password}});
}

void APIClient::request(const QString &endpoint, Method method,
                        const QJsonObject &data) {
  // Creating the request.
  QNetworkRequest request(
      QUrl(QString("http://127.0.0.1:9292/%1").arg(endpoint)));

  request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
  QByteArray json = QJsonDocument(data).toJson();

  QNetworkReply *reply = nullptr;

  switch (method) {
  case Method::GET: {
    reply = _manager->get(request);
    break;
  }

  case Method::POST: {
    reply = _manager->post(request, json);
    break;
  }

  case Method::PUT: {
    reply = _manager->put(request, json);
    break;
  }

  case Method::DELETE: {
    reply = _manager->deleteResource(request);
    break;
  }
  }

  connect(
      reply, &QNetworkReply::finished, this,
      [this, reply]() { handleResponse(reply); }, Qt::QueuedConnection);
}

void APIClient::request(const QString &query) {
  QNetworkRequest request(QUrl("http://127.0.0.1:9292/graphql"));
  request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

  if (!_token.isEmpty()) {
    request.setRawHeader("Authorization", "Bearer " + _token.toUtf8());
  }

  // Creating a JSON object with the query.
  QJsonObject requestData = {{"query", query}};
  QByteArray postData = QJsonDocument(requestData).toJson();

  // Sending the request.
  QNetworkReply *reply = _manager->post(request, postData);

  connect(
      reply, &QNetworkReply::finished, this,
      [this, reply]() { handleGraphql(reply); }, Qt::QueuedConnection);
}

void APIClient::handleResponse(QNetworkReply *reply) {
  if (reply->error() == QNetworkReply::NoError) {
    QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
    QJsonObject jsonObj = jsonDoc.object();

    if (reply->url().toString() == "http://127.0.0.1:9292/login") {
      if (jsonObj.contains("error")) {
        _token.clear();

        reply->deleteLater();
        return;
      }

      _token = jsonObj["token"].toString();
      _isLoggedIn = !_token.isEmpty();

      emit onLoginChange();
    }

    emit onResponse(jsonObj);
  }

  else {
    emit onResponse(QJsonObject{{"error", reply->errorString()}});
  }

  reply->deleteLater();
}

void APIClient::handleGraphql(QNetworkReply *reply) {
  if (reply->error() == QNetworkReply::NoError) {
    QJsonDocument jsonDoc = QJsonDocument::fromJson(reply->readAll());
    QJsonObject jsonObj = jsonDoc.object();

    if (jsonObj["data"].toObject().contains("getRecipe")) {
      QJsonObject recipeData =
          jsonObj["data"].toObject()["getRecipe"].toObject();

      // emit onRecipeLoaded(recipeData);
    }

    if (jsonObj["data"].toObject().contains("filterRecipes")) {
      QJsonArray recipes =
          jsonObj["data"].toObject()["filterRecipes"].toArray();

      // emit onRecipesFiltered(recipes);
    }

    emit onGraphql(jsonObj);
  }

  else {
    emit onGraphql(QJsonObject{{"error", reply->errorString()}});
  }

  reply->deleteLater();
}
