#ifndef GVPublicObj_H
#define GVPublicObj_H
#include <QString>
#include "myprintf.h"
#include <QtQml>
#include "qmlpublicobj.h"

using namespace std;

typedef struct _FrameWorkShare
{
    QString info;
    bool* pWorkOut;
}FrameWorkShare;

class GVPublicObj
{
public:
    GVPublicObj();
    ~GVPublicObj();
	void setPFrameWorkShare(FrameWorkShare *value);
	string info();
	
    void registerToQML();

private:
	FrameWorkShare* pFrameWorkShare;
};

#endif // GVPublicObj_H
