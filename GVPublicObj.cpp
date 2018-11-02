#include "GVPublicObj.h"
#include <QtQml>

GVPublicObj::GVPublicObj()
{
    pFrameWorkShare = NULL;
}

GVPublicObj::~GVPublicObj()
{

}

void GVPublicObj::setPFrameWorkShare(FrameWorkShare *value)
{
    pFrameWorkShare = value;
}

string GVPublicObj::info(void)
{
    if(pFrameWorkShare)
    {
        return pFrameWorkShare->info.toStdString();
    }
    else
    {
        return "no pFrameWorkShare value";
    }
}

void GVPublicObj::registerToQML()
{
    qmlRegisterType<QMLPublicObj>("com.qt.qmlPublicObj",1,0,"GVPublicObj");
}

