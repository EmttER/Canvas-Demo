#include "qmlpublicobj.h"

QMLPublicObj::QMLPublicObj()
{
    //null
}

QString QMLPublicObj::getIniValueByArray(const QString &iniPath, const QString &JSONString)
{
    QJsonArray jsonArray = QJsonDocument::fromJson(JSONString.toUtf8()).array();
    if(jsonArray.size()<=0||iniPath.isEmpty()){
        return "";
    }
    QJsonArray arrayReturn;
    QSettings settingp(iniPath, QSettings::IniFormat);
    for(int i = 0;i < jsonArray.size();i++){
        QJsonObject objs= jsonArray.at(i).toObject();
        QString key = objs.value("key").toString("no");
        if(key == "no"){
            return "";
        }
        QString value = settingp.value(key).toString();
        QJsonObject objReturn;
        objReturn.insert("key",key);
        objReturn.insert("value",value);
        arrayReturn.insert(arrayReturn.size(),objReturn);
    }
    return QJsonDocument(arrayReturn).toJson();

}

QString QMLPublicObj::getApplicationPath() const
{
    return QCoreApplication::applicationDirPath();
}

bool QMLPublicObj::setIniValueByArray(const QString &iniPath, const QString &JSONString)
{

    QJsonArray jsonArray = QJsonDocument::fromJson(JSONString.toUtf8()).array();
    if(jsonArray.size()<=0||iniPath.isEmpty()){
        return false;
    }

    QSettings settingp(iniPath, QSettings::IniFormat);
    for(int i = 0;i < jsonArray.size();i++){
        QJsonObject objs= jsonArray.at(i).toObject();
        QString key = objs.value("key").toString("no");
        QString value = objs.value("value").toString("no");
        if(key == "no" || value == "no"){
            return false;
        }
        settingp.setValue(key,value);
    }
    return true;
}
