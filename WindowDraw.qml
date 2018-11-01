import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2
import com.qt.qmlPublicObj 1.0
import "GVColor.js" as GVColor
import "GVFont.js" as GVFont

Window{
    id:windowForDraw
    width: 1100
    height: 600
    maximumWidth: 1100
    maximumHeight: 600
    minimumWidth: 1100
    minimumHeight: 600
    title: "Demo For Drawing Graphs Version1.0.4"

    property string filePath: "" //图片路径
    property bool hasPicture: false //当前是否有图片被加载

    property int modeSet: 0 //模式设置参数,0为移动，1为直线，2为矩形，3为圆
    property string modeName: "UNKNOWN" //模式名称
    property bool isChanging: false //是否正在修改图形参数

    property double scaleValue: 1.1 //放大/缩小比例，定值
    property int scaleLevel: 0 //当前放大/缩小的数值
    property double aspectRatio: 1.0 //计算原图长宽比
    property int originPicWidth: 0 //初始化时保存原图长
    property int originPicHeight: 0 //初始化时保存原图宽

    property int lineNumber: 0 //用于记录直线的数量
    property int rectNumber: 0 //用于记录矩形的数量
    property int cycleNumber: 0 //用于记录圆形的数量

    //==========数组，用于记录所有操作的数据==========
    property var graph: []

    //==========数组，用于记录直线操作的数据==========
    property var lineStartX: [] //用于保存原图每条直线起点的X坐标
    property var lineStartY: [] //用于保存原图每条直线起点的Y坐标
    property var lineEndX: [] //用于保存原图每条直线终点的X坐标
    property var lineEndY: [] //用于保存原图每条直线终点的Y坐标

    //==========数组，用于记录矩形操作的数据==========
    property var rectStartX: [] //用于保存矩形起点的X坐标
    property var rectStartY: [] //用于保存矩形起点的Y坐标
    property var rectEndX: [] //用于保存矩形终点的X坐标
    property var rectEndY: [] //用于保存矩形终点的Y坐标
    property var rectCenterX: [] //用于保存矩形中心点的X坐标
    property var rectCenterY: [] //用于保存矩形中心点的Y坐标
    property var rectWidth: [] //用于保存矩形的实际长度
    property var rectHeight: [] //用于保存矩形的实际宽度

    //==========数组，用于记录圆形的圆心和半径==========
    property var cycleCenterX: [] //用于保存圆形圆心的X坐标
    property var cycleCenterY: [] //用于保存圆形圆心的Y坐标
    property var cycleRadius: [] //用于保存圆形的半径

    //公用方法publicObj
    GVPublicObj{
        id: publicObj
    }

    //工具栏
    Rectangle{
        id: toolBar
        width: 50
        height: parent.height
        color: "#535353"
        anchors.left: parent.left
        anchors.top: parent.top
        z:100

        //移动,放大和缩小图片按钮
        Button{
            id: shiftBtn
            width: 4*parent.width/5
            height: shiftBtn.width
            anchors.top: parent.top
            anchors.topMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            style: ButtonStyle{
                label: Text{
                    text: "查看"
                    font.family: GVFont.FONT_SIMSUN
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            onClicked: {
                modeSet = 0
                toolBar.changeMode()
            }
        }
        //绘制直线按钮
        Button{
            id: drawLineBtn
            width: 4*parent.width/5
            height: drawLineBtn.width
            anchors.top: shiftBtn.bottom
            anchors.topMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            style: ButtonStyle{
                label: Text{
                    text: "直线"
                    font.family: GVFont.FONT_SIMSUN
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            onClicked: {
                modeSet = 1
                isChanging = false
                toolBar.changeMode()
            }
        }
        //绘制矩形按钮
        Button{
            id: drawRectBtn
            width: 4*parent.width/5
            height: drawRectBtn.width
            anchors.top: drawLineBtn.bottom
            anchors.topMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            style: ButtonStyle{
                label: Text{
                    text: "矩形"
                    font.family: GVFont.FONT_SIMSUN
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            onClicked: {
                modeSet = 2
                isChanging = false
                toolBar.changeMode()
            }
        }

        //绘制圆形按钮
        Button{
            id: drawCycleBtn
            width: 4*parent.width/5
            height: drawCycleBtn.width
            anchors.top: drawRectBtn.bottom
            anchors.topMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            style: ButtonStyle{
                label: Text{
                    text: "圆"
                    font.family: GVFont.FONT_SIMSUN
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            onClicked: {
                modeSet = 3
                isChanging = false
                toolBar.changeMode()
            }
        }

        //==========清空ini文件，待删==========
        Button{
            id: clearBtn
            width: 4*parent.width/5
            height: drawCycleBtn.width
            anchors.bottom: saveBtn.top
            anchors.bottomMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            style: ButtonStyle{
                label: Text{
                    text: "清空"
                    font.family: GVFont.FONT_SIMSUN
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            onClicked: {
                clearIniFile()
                clearBasicData()
                isChanging = false
            }
        }
        //==========保存相关参数到ini文件，待改，后期结合算法函数==========
        Button{
            id: saveBtn
            width: 4*parent.width/5
            height: drawCycleBtn.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            style: ButtonStyle{
                label: Text{
                    text: "保存"
                    font.family: GVFont.FONT_SIMSUN
                    font.pointSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            onClicked: {
                save2File()
                isChanging = false
            }
        }

        function changeMode()
        {
            if(modeSet === 0){
                mouseArea.drag.target = picture
            }else{
                mouseArea.drag.target = pictureForDrag
            }
        }

    }

    //图形区域
    Rectangle{
        id: pictureBar
        width: parent.width - toolBar.width
        height: parent.height
        color: "#282828"
        anchors.left: toolBar.right
        anchors.top: parent.top

        property bool isDrawingLine: false
        property bool isDrawingRect: false
        property bool isDrawingCycle: false

        Image{
            id: picture
            source: "defaultImage.jpg"
            visible: false
            fillMode: Image.PreserveAspectFit
        }

        Image{
            id: pictureForDrag
            source: "defaultImage.jpg"
            visible: false
        }

        Canvas{
            id: drawGraph
            anchors.fill: picture
            contextType: "2d"
            visible: true

            //绘制直线所需参数
            property int lineStartX4Cvs: 0
            property int lineStartY4Cvs: 0
            property int lineEndX4Cvs: 0
            property int lineEndY4Cvs: 0

            //绘制矩形所需参数
            property int rectStartX4Cvs: 0
            property int rectStartY4Cvs: 0
            property int rectEndX4Cvs: 0
            property int rectEndY4Cvs: 0
            property int rectWidth: 0
            property int rectHeight: 0

            //绘制圆形所需参数
            property int cycleStartX4Cvs: 0
            property int cycleStartY4Cvs: 0
            property int cycleEndX4Cvs: 0
            property int cycleEndY4Cvs: 0
            property int radius4Cvs: 0

            onPaint: {
                drawFunc()
            }

            function drawFunc()
            {
                //设置画笔属性
                var ctx = drawGraph.getContext("2d")
                ctx.clearRect(0,0,drawGraph.width,drawGraph.height)
                ctx.lineWidth = 2
                ctx.strokeStyle = GVColor.COLOR_PAINTBORDER

                //=====还原已绘制的直线=====
                if(lineEndX.length !== 0){
                    for(var j=0; j<lineEndX.length; j++ ){
                        var newStartX = (picture.width * lineStartX[j]) / originPicWidth
                        var newStartY = (picture.height * lineStartY[j]) / originPicHeight
                        var newEndX = (picture.width * lineEndX[j]) / originPicWidth
                        var newEndY = (picture.height * lineEndY[j]) / originPicHeight

                        ctx.beginPath()
                        ctx.moveTo(newStartX,newStartY)
                        ctx.lineTo(newEndX,newEndY)
                        ctx.stroke()
                        ctx.closePath()
                    }
                }
                //=====还原已绘制的矩形=====
                if(rectEndX.length !== 0){
                    for(var m=0; m<rectEndX.length; m++){
                        var newRectStartX = (picture.width * rectStartX[m]) / originPicWidth
                        var newRectStartY = (picture.height * rectStartY[m]) / originPicHeight
                        var newRectEndX = (picture.width * rectEndX[m]) / originPicWidth
                        var newRectEndY = (picture.height * rectEndY[m]) / originPicHeight
                        var newRectWidth = newRectEndX - newRectStartX
                        var newRectHeight = newRectEndY - newRectStartY

                        ctx.beginPath()
                        ctx.rect(newRectStartX,newRectStartY,newRectWidth,newRectHeight)
                        ctx.stroke()
                        ctx.closePath()
                    }
                }
                //=====还原已绘制的圆形=====
                if(cycleRadius.length !== 0){
                    for(var n=0; n<cycleRadius.length; n++){
                        var newCycleCenterX = (picture.width * cycleCenterX[n]) / originPicWidth
                        var newCycleCenterY = (picture.height * cycleCenterY[n]) / originPicHeight
                        var newRadius = (picture.width * cycleRadius[n]) / originPicWidth

                        ctx.beginPath()
                        ctx.arc(newCycleCenterX,newCycleCenterY,newRadius,0,Math.PI*2,true)
                        ctx.stroke()
                        ctx.closePath()

                        ctx.beginPath()
                        ctx.arc(newCycleCenterX,newCycleCenterY,1,0,Math.PI*2,true)
                        ctx.stroke()
                        ctx.closePath()
                    }
                }

                //=====绘制新的图形=====
                //===此时为绘制直线模式===
                if(modeSet === 1){
                    if(pictureBar.isDrawingLine === true){
                        ctx.beginPath()
                        ctx.moveTo(lineStartX4Cvs,lineStartY4Cvs)
                        ctx.lineTo(lineEndX4Cvs,lineEndY4Cvs)
                        ctx.stroke()
                        ctx.closePath()
                    }
                }
                //===此时为绘制矩形模式===
                else if(modeSet === 2){
                    if(pictureBar.isDrawingRect === true){
                        ctx.beginPath()
                        ctx.rect(rectStartX4Cvs,rectStartY4Cvs,rectWidth,rectHeight)
                        ctx.stroke()
                        ctx.closePath()
                    }
                }
                //===此时为绘制圆形模式===
                else if(modeSet === 3){
                    if(pictureBar.isDrawingCycle === true){
                        ctx.beginPath()
                        ctx.arc(cycleStartX4Cvs,cycleStartY4Cvs,radius4Cvs,0,Math.PI*2)
                        ctx.stroke()
                        ctx.closePath()

                        ctx.beginPath()
                        ctx.arc(cycleStartX4Cvs,cycleStartY4Cvs,1,0,Math.PI*2)
                        ctx.stroke()
                        ctx.closePath()
                    }
                }
            }
        }

        MouseArea{
            id: mouseArea
            anchors.fill: drawGraph
            hoverEnabled: true
            drag.target: picture
            drag.axis: Drag.XAndYAxis
            focus: true
            Keys.enabled: true

            //鼠标双击
            onDoubleClicked: {
                console.log("=====已存数组为：=====")
                console.log(lineStartX)
                console.log(lineStartY)
            }
            //鼠标按下,开始绘制
            onPressed: {
                //此时为绘制直线模式
                if(modeSet === 1){
                    drawGraph.lineStartX4Cvs = mouseX
                    drawGraph.lineStartY4Cvs = mouseY

                    var realLineX = (mouseX * originPicWidth) / picture.width
                    var realLineY = (mouseY * originPicHeight) / picture.height

                    lineStartX.push(realLineX.toFixed(2))
                    lineStartY.push(realLineY.toFixed(2))

                    pictureBar.isDrawingLine = true
                    pictureBar.isDrawingRect = false
                    pictureBar.isDrawingCycle = false
                }
                //此时为绘制矩形模式
                else if(modeSet === 2){
                    drawGraph.rectStartX4Cvs = mouseX
                    drawGraph.rectStartY4Cvs = mouseY

                    var realRectX = (mouseX * originPicWidth) / picture.width
                    var realRectY = (mouseY * originPicHeight) / picture.height

                    rectStartX.push(realRectX.toFixed(2))
                    rectStartY.push(realRectY.toFixed(2))

                    pictureBar.isDrawingLine = false
                    pictureBar.isDrawingRect = true
                    pictureBar.isDrawingCycle = false
                }
                //此时为绘制圆形模式
                else if(modeSet === 3){
                    drawGraph.cycleStartX4Cvs = mouseX
                    drawGraph.cycleStartY4Cvs = mouseY

                    var realCycleX = (mouseX * originPicWidth) / picture.width
                    var realCycleY = (mouseY * originPicHeight) / picture.height

                    cycleCenterX.push(realCycleX.toFixed(2))
                    cycleCenterY.push(realCycleY.toFixed(2))

                    pictureBar.isDrawingLine = false
                    pictureBar.isDrawingRect = false
                    pictureBar.isDrawingCycle = true
                }
            }
            //鼠标松开,绘制完成
            onReleased: {
                //此时为绘制直线模式
                if(modeSet === 1){
                    drawGraph.lineEndX4Cvs = mouseX
                    drawGraph.lineEndY4Cvs = mouseY

                    var realLineX = (mouseX * originPicWidth) / picture.width
                    var realLineY = (mouseY * originPicHeight) / picture.height

                    lineEndX.push(realLineX.toFixed(2))
                    lineEndY.push(realLineY.toFixed(2))

                    pictureBar.isDrawingLine = false

                    var lineStr = "line"+lineEndX.length.toString()
                    graph.push(lineStr)
                    historyRecordModel.append({"operation":"直线"})
                }
                //此时为绘制矩形模式
                else if(modeSet === 2){
                    drawGraph.rectEndX4Cvs = mouseX
                    drawGraph.rectEndY4Cvs = mouseY

                    var realRectX = (mouseX * originPicWidth) / picture.width
                    var realRectY = (mouseY * originPicHeight) / picture.height
                    rectEndX.push(realRectX.toFixed(2))
                    rectEndY.push(realRectY.toFixed(2))

                    //计算矩形中心点
                    var arrayLength = rectEndX.length
                    var realCenterX = (parseInt(rectStartX[arrayLength-1]) + parseInt(rectEndX[arrayLength-1])) / 2
                    var realCenterY = (parseInt(rectStartY[arrayLength-1]) + parseInt(rectEndY[arrayLength-1])) / 2

                    rectCenterX.push(realCenterX.toFixed(2))
                    rectCenterY.push(realCenterY.toFixed(2))

                    //计算矩形长宽
                    var realRectWidth = Math.abs(rectStartX[arrayLength-1] - rectEndX[arrayLength-1])
                    var realRectHeight = Math.abs(rectStartY[arrayLength-1] - rectEndY[arrayLength-1])
                    rectWidth.push(realRectWidth.toFixed(2))
                    rectHeight.push(realRectHeight.toFixed(2))

                    drawGraph.rectWidth = drawGraph.rectEndX4Cvs - drawGraph.rectStartX4Cvs
                    drawGraph.rectHeight = drawGraph.rectEndY4Cvs - drawGraph.rectStartY4Cvs

                    pictureBar.isDrawingRect = false

                    var rectStr = "rect"+rectEndX.length.toString()
                    graph.push(rectStr)
                    historyRecordModel.append({"operation":"矩形"})
                }
                //此时为绘制圆形模式
                else if(modeSet === 3){
                    drawGraph.cycleEndX4Cvs = mouseX
                    drawGraph.cycleEndY4Cvs = mouseY

                    var xDistance = Math.abs(drawGraph.cycleStartX4Cvs - drawGraph.cycleEndX4Cvs)
                    var yDistance = Math.abs(drawGraph.cycleStartY4Cvs - drawGraph.cycleEndY4Cvs)
                    var distance = Math.sqrt((Math.pow(xDistance,2)+Math.pow(yDistance,2)))
                    drawGraph.radius4Cvs = distance
                    var realRadius = (distance * originPicWidth) / picture.width
                    cycleRadius.push(realRadius.toFixed(2))

                    pictureBar.isDrawingCycle = false

                    var cycleStr = "cylec"+cycleRadius.length.toString()
                    graph.push(cycleStr)
                    historyRecordModel.append({"operation":"圆"})
                }

            }
            //鼠标移动,正在绘制
            onPositionChanged: {
                //此时为绘制直线模式
                if(modeSet === 1){
                    if(pictureBar.isDrawingLine === true){
                        drawGraph.lineEndX4Cvs = mouseX
                        drawGraph.lineEndY4Cvs = mouseY

                        drawGraph.requestPaint() //请求绘制
                    }
                }
                //此时为绘制矩形模式
                else if(modeSet === 2){
                    if(pictureBar.isDrawingRect === true){
                        drawGraph.rectWidth = mouseX - drawGraph.rectStartX4Cvs
                        drawGraph.rectHeight = mouseY - drawGraph.rectStartY4Cvs

                        drawGraph.requestPaint() //请求绘制
                    }
                }
                //此时为绘制圆形模式
                else if(modeSet === 3){
                    if(pictureBar.isDrawingCycle === true){
                        drawGraph.cycleEndX4Cvs = mouseX
                        drawGraph.cycleEndY4Cvs = mouseY

                        var xDistance = Math.abs(drawGraph.cycleStartX4Cvs - drawGraph.cycleEndX4Cvs)
                        var yDistance = Math.abs(drawGraph.cycleStartY4Cvs - drawGraph.cycleEndY4Cvs)
                        var distance = Math.sqrt((Math.pow(xDistance,2)+Math.pow(yDistance,2)))
                        drawGraph.radius4Cvs = distance

                        drawGraph.requestPaint()//请求绘制
                    }
                }
            }
            //鼠标滚轮转动
            onWheel: {
                //如果此时是移动模式，则可以拖动图片和放大/缩小图片
                if(modeSet === 0){
                    if(wheel.angleDelta.y > 0 && scaleLevel <= 25){
                        //图像放大处理
                        picture.transformOriginPoint.x = wheel.x
                        picture.transformOriginPoint.y = wheel.y
                        zoomIn(wheel.x,wheel.y)
                    }
                    else if(wheel.angleDelta.y < 0 && scaleLevel >= -25){
                        //图像缩小处理
                        picture.transformOriginPoint.x = wheel.x
                        picture.transformOriginPoint.y = wheel.y
                        zoomOut(wheel.x,wheel.y)
                    }
                }
            }

            Keys.onEnterPressed: {
                console.log("触发Enter键按下信号")
            }

            //放大函数
            function zoomIn(x,y)
            {
                var beforeWidth = picture.width
                var beforeHeight = picture.height
                picture.width = picture.width * scaleValue
                picture.height = picture.height * scaleValue
                mouseArea.width = picture.width
                mouseArea.height = picture.height

                picture.x = picture.x + x - picture.width  * x / beforeWidth
                picture.y = picture.y + y - picture.height * y / beforeHeight

                scaleLevel++
            }

            //缩小函数
            function zoomOut(x,y)
            {
                var beforeWidth  = picture.width
                var beforeHeight = picture.height
                picture.width = picture.width / scaleValue
                picture.height = picture.height / scaleValue
                mouseArea.width = picture.width
                mouseArea.height = picture.height

                picture.x = picture.x + x - picture.width  * x / beforeWidth
                picture.y = picture.y + y - picture.height * y / beforeHeight
                scaleLevel--
            }
        }

        DropArea{
            id: dropArea
            anchors.fill: parent
            onDropped: {
                if(drop.hasUrls){ //如果图片URL(s)有效
                    clearBasicData() //清空数据
                    historyRecordModel.clear()
                    modeSet = 0
                    scaleLevel = 0

                    //传递图片路径
                    for(var i=0; i<drop.urls.length; i++){
                        picture.source = drop.urls[i]
                        picture.visible = true
                        getPictureAttributes() //获取原图属性
                        showPicture() //设置图片合理显示
                     }
                }
            }
        }

        Component.onCompleted: {
            isDrawingLine = false
            isDrawingRect = false
            isDrawingCycle = false
        }
    }

    //历史操作选择区域
    Rectangle{
        id: selectBar
        width: 150
        height: parent.height
        color: "#535353"
        anchors.right: parent.right
        anchors.top: parent.top
        //=====此处为"历史操作"的预留区域，方便修改已绘制图形属性=====

        TableView{
            id: historyRecordTable
            model: historyRecordModel
            width: selectBar.width
            height: selectBar.height+30
            TableViewColumn{
                role: "operation"
                title: "历史操作"
                width: selectBar.width-2
                movable: false
                resizable: false
            }

            headerDelegate: Rectangle{
                height: selectBar.height/15
                width: selectBar.width-2
                color: "#535353"
                Text{
                    anchors.centerIn: parent
                    text: styleData.value
                    color: "#FFF0C6"
                    font.family: GVFont.FONT_SIMHEI
                }
            }
            rowDelegate: Rectangle{
                height: selectBar.height/15
                color: "#535353"
            }
            itemDelegate: Rectangle{
                width: selectBar.width
                color: "#767676"
                Text{
                    color: "#FFF0C6"
                    anchors.centerIn: parent
                    text: styleData.value
                }
                border.color: "#282828"
                border.width: 1
            }

            onClicked: {
                console.log("=====捕捉到点击第"+(row+1)+"行数据=====")
                console.log("=====点击的数据在graph数组中对应的值为:"+graph[row]+"=====")
                console.log("保存所有图形操作的graph数组的内容为:")
                for(var x=0; x<graph.length; x++)
                {
                    console.log("第"+(x+1)+"项为:"+graph[x])
                }
                drawGraph.requestPaint()
            }
        }
    }

    ListModel{
        id: historyRecordModel
    }

    Component.onCompleted: {
        modeSet = 0
        hasPicture = false
        filePath = publicObj.getApplicationPath()+"/GRAPHDATA.ini"
        console.log("=====ini文件路径为:"+filePath+"=====")
        historyRecordModel.clear()
    }

    //清空数据函数
    function clearBasicData()
    {
        //清空原图数据
        originPicWidth = 0
        originPicHeight = 0
        //清空所有直线相关数据
        lineStartX = []
        lineStartY = []
        lineEndX = []
        lineEndY = []
        //清空所有矩形相关数据
        rectStartX = []
        rectStartY = []
        rectEndX = []
        rectEndY = []
        rectCenterX = []
        rectCenterY = []
        rectWidth = []
        rectHeight = []
        //清空所有圆形相关数据
        cycleCenterX = []
        cycleCenterY = []
        cycleRadius = []
    }

    //获取原图属性函数
    function getPictureAttributes()
    {
        var picSize = picture.sourceSize.toString() //获取图片尺寸，qSize转string

        var indexLeft = picSize.indexOf("(")
        var indexComma = picSize.indexOf(",")
        var indexRight = picSize.indexOf(")")
        var indexBlank = picSize.indexOf(" ")

        var widthStr = picSize.substring(indexLeft+1,indexComma)
        var heightStr = picSize.substring(indexBlank+1,indexRight)
        originPicWidth = parseInt(widthStr) //获得原图长
        originPicHeight = parseInt(heightStr) //获得原图宽

        aspectRatio = originPicWidth / originPicHeight // 获得原图长宽比

        console.log("原图的长为:"+originPicWidth+",宽为:"+originPicHeight+",长宽比为:"+aspectRatio)
    }

    //显示图片在区域中心并适配图片大小
    function showPicture()
    {
        //=====情况一:图片长和宽都小于rect的长和宽=====
        if(originPicWidth < pictureBar.width && originPicHeight < pictureBar.height){
            picture.width = originPicWidth
            picture.height = originPicHeight

            picture.x = (pictureBar.width - picture.width)/2
            picture.y = (pictureBar.height - picture.height)/2
        }
        //=====情况二：图片尺寸不能完全适配rect的尺寸=====
        else{
            var virtualWidth = aspectRatio*pictureBar.height
            var virtualHeight = pictureBar.width/aspectRatio

            if(virtualWidth <= pictureBar.width){
                picture.width = virtualWidth
                picture.height = pictureBar.height
                picture.x = (pictureBar.width -virtualWidth)/2
                picture.y = 0
            }
            else if(virtualHeight <= pictureBar.height){
                picture.width = pictureBar.width
                picture.height = virtualHeight
                picture.x = 0
                picture.y = (pictureBar.height - virtualHeight)/2
            }
        }
    }

    //清空Ini文件函数，待删
    function clearIniFile()
    {
        //清空图片数据
        var widthContent = [{key:'PICINFO/WIDTH',value:""}]
        var heightContent = [{key:'PICINFO/HEIGHT',value:""}]
        publicObj.setIniValueByArray(filePath,JSON.stringify(widthContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(heightContent))

        //清空直线数据
        var startSpotXContent = [{key:'LINEINFO/STARTSPOTX',value:""}]
        var startSpotYContent = [{key:'LINEINFO/STARTSPOTY',value:""}]
        var endSpotXContent = [{key:'LINEINFO/ENDSPOTX',value:""}]
        var endSpotYContent = [{key:'LINEINFO/ENDSPOTY',value:""}]

        publicObj.setIniValueByArray(filePath,JSON.stringify(startSpotXContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(startSpotYContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(endSpotXContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(endSpotYContent))

        //清空矩形数据
        var centerSpotXContent = [{key:'RECTINFO/CENTERSPOTX',value:""}]
        var centerSpotYContent = [{key:'RECTINFO/CENTERSPOTY',value:""}]
        var rectWidthDataContent = [{key:'RECTINFO/RECTWIDTH',value:""}]
        var rectHeightDataContent = [{key:'RECTINFO/RECTHEIGHT',value:""}]

        publicObj.setIniValueByArray(filePath,JSON.stringify(centerSpotXContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(centerSpotYContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(rectWidthDataContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(rectHeightDataContent))

        //清空圆形数据
        var cycleCenterSpotXContent = [{key:'CYCLEINFO/CYCLECENTERSPOTX',value:""}]
        var cycleCenterSpotYContect = [{key:'CYCLEINFO/CYCLECENTERSPOTY',value:""}]
        var rLengthContect = [{key:'CYCLEINFO/RLENGTH',value:""}]

        publicObj.setIniValueByArray(filePath,JSON.stringify(cycleCenterSpotXContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(cycleCenterSpotYContect))
        publicObj.setIniValueByArray(filePath,JSON.stringify(rLengthContect))

    }

    //写入数据到Ini文件函数，待删
    function save2File()
    {
        console.log("进入到写入ini文件函数")
        //写入新数据之前先清除之前的数据
        clearIniFile()
        //写入图片数据
        var widthData = originPicWidth.toString()
        var heightData = originPicHeight.toString()

        var widthContent = [{key:'PICINFO/WIDTH',value:widthData}]
        var heightContent = [{key:'PICINFO/HEIGHT',value:heightData}]

        publicObj.setIniValueByArray(filePath,JSON.stringify(widthContent))
        publicObj.setIniValueByArray(filePath,JSON.stringify(heightContent))

        //写入直线数据
        if(lineEndX.length >= 1){
            var startSpotX = lineStartX[0].toString()
            var startSpotY = lineStartY[0].toString()
            var endSpotX = lineEndX[0].toString()
            var endSpotY = lineEndY[0].toString()

            for(var o=1; o<lineEndX.length; o++){
                startSpotX = startSpotX + " " + lineStartX[o].toString()
                startSpotY = startSpotY + " " + lineStartY[o].toString()
                endSpotX = endSpotX + " " + lineEndX[o].toString()
                endSpotY = endSpotY + " " + lineEndY[o].toString()
            }

            var startSpotXContent = [{key:'LINEINFO/STARTSPOTX',value:startSpotX}]
            var startSpotYContent = [{key:'LINEINFO/STARTSPOTY',value:startSpotY}]
            var endSpotXContent = [{key:'LINEINFO/ENDSPOTX',value:endSpotX}]
            var endSpotYContent = [{key:'LINEINFO/ENDSPOTY',value:endSpotY}]

            publicObj.setIniValueByArray(filePath,JSON.stringify(startSpotXContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(startSpotYContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(endSpotXContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(endSpotYContent))
        }

        //写入矩形数据
        if(rectEndX.length >= 1){
            var centerSpotX = rectCenterX[0].toString()
            var centerSpotY = rectCenterY[0].toString()
            var rectWidthData = rectWidth[0].toString()
            var rectHeightData = rectHeight[0].toString()

            for(var p=1; p<rectEndY.length; p++){
                centerSpotX = centerSpotX+" "+rectCenterX[p].toString()
                centerSpotY = centerSpotY+" "+rectCenterY[p].toString()
                rectWidthData = rectWidthData+" "+rectWidth[p].toString()
                rectHeightData = rectHeightData+" "+rectHeight[p].toString()
            }

            var centerSpotXContent = [{key:'RECTINFO/CENTERSPOTX',value:centerSpotX}]
            var centerSpotYContent = [{key:'RECTINFO/CENTERSPOTY',value:centerSpotY}]
            var rectWidthDataContent = [{key:'RECTINFO/RECTWIDTH',value:rectWidthData}]
            var rectHeightDataContent = [{key:'RECTINFO/RECTHEIGHT',value:rectHeightData}]

            publicObj.setIniValueByArray(filePath,JSON.stringify(centerSpotXContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(centerSpotYContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(rectWidthDataContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(rectHeightDataContent))
        }

        //写入圆形数据
        if(cycleRadius.length >= 1){
            var cycleCenterSpotX = cycleCenterX[0].toString()
            var cycleCenterSpotY = cycleCenterY[0].toString()
            var rLength = cycleRadius[0].toString()

            for(var c=1; c<cycleRadius.length; c++){
                cycleCenterSpotX = cycleCenterSpotX+" "+cycleCenterX[c].toString()
                cycleCenterSpotY = cycleCenterSpotY+" "+cycleCenterY[c].toString()
                rLength = rLength+" "+cycleRadius[c].toString()
            }

            var cycleCenterSpotXContent = [{key:'CYCLEINFO/CYCLECENTERSPOTX',value:cycleCenterSpotX}]
            var cycleCenterSpotYContent = [{key:'CYCLEINFO/CYCLECENTERSPOTY',value:cycleCenterSpotY}]
            var rLengthContent = [{key:'CYCLEINFO/RLENGTH',value:rLength}]

            publicObj.setIniValueByArray(filePath,JSON.stringify(cycleCenterSpotXContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(cycleCenterSpotYContent))
            publicObj.setIniValueByArray(filePath,JSON.stringify(rLengthContent))
        }

    }

}
