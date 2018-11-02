#ifndef QMLPUBLICOBJ_H
#define QMLPUBLICOBJ_H

#include <QObject>
#include <QString>
#include <QSettings>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QCoreApplication>

class QMLPublicObj : public QObject
{
    Q_OBJECT
public:
    QMLPublicObj();

    Q_INVOKABLE QString getIniValueByArray(const QString &iniPath, const QString &JSONString);
    Q_INVOKABLE QString getApplicationPath() const;
    Q_INVOKABLE bool setIniValueByArray(const QString &iniPath, const QString &JSONString);
};

#endif // QMLPUBLICOBJ_H
