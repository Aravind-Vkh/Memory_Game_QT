import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.15
import QtQuick.VirtualKeyboard 2.4
import Memory_Game 1.0

Window {
    id: memoryGameWindow
    width: 1200
    height: 600
    visible: true
    title: qsTr("Memory Game")

    readonly property int numMatched: _memoryGame.matchedSet
    readonly property int numTrials: _memoryGame.numTrials
    readonly property int prevColIdx: _memoryGame.previousColIdx
    readonly property int prevRowIdx: _memoryGame.previousRowIdx
    readonly property var alphabetState: _memoryGame.alphabetState
    readonly property bool acceptMouseEvents: _memoryGame.acceptMouseEvents
    property int curColIdx: 0
    property int curRowIdx: 0

    /* Maximum Matched Points for Winning */
    readonly property int maxMatchedPoints: 12

    /* Current Index of the Level of the MemoryGame */
    property int comboBoxIdx: 0

    /* Number of Maximum Trials based on Game Level */
    property int maxTrials: maxTrialsForEasy
    readonly property int maxTrialsForEasy: 40
    readonly property int maxTrialsForMedium: 30
    readonly property int maxTrialsForHard: 20

    ListModel {
        id: modelRow1
        ListElement { property var alphabet: qsTr("A"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("Z"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("B"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("Y"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("X"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
    }

    ListModel {
        id: modelRow2
        ListElement { property var alphabet: qsTr("C"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("W"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("D"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("V"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("E"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
    }

    ListModel {
        id: modelRow3
        ListElement { property var alphabet: qsTr("F"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("U"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("A"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("C"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("Z"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
    }

    ListModel {
        id: modelRow4
        ListElement { property var alphabet: qsTr("W"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("B"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("D"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("Y"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("V"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
    }

    ListModel {
        id: modelRow5
        ListElement { property var alphabet: qsTr("X"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("E"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("F"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("U"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
        ListElement { property var alphabet: qsTr("O"); property int internalState: MemoryGame.INTERNAL_STATE_NEW }
    }

    ListModel {
        id: modelRows
        ListElement { property var rowModel: function() { return modelRow1; } }
        ListElement { property var rowModel: function() { return modelRow2; } }
        ListElement { property var rowModel: function() { return modelRow3; } }
        ListElement { property var rowModel: function() { return modelRow4; } }
        ListElement { property var rowModel: function() { return modelRow5; } }
    }

    /* Column for Contents on Right Side such as Real Time Results, 3 Buttons and its corresponding Backend Functionality */
    Column {
        anchors {
            right: parent.right
            rightMargin: 5
            left: outterRectangle.right
            leftMargin: 10
            top: parent.top
            topMargin: 50
        }
        spacing: 10
        Row {
            id: mainContentMainTextLine1
            spacing: 20
            Text {
                id: mainContentMatchedTextLine
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Matches:" )
            }

            Text {
                id: mainContentMatchedTextValue
                horizontalAlignment: Text.AlignRight
                text: Number(numMatched).toString()
            }
        }

        Row {
            id: mainContentTrialsText
            spacing: 40
            Text {
                id: mainContentTrialsLine
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Turns:" )
            }

            Text {
                id: mainContentTrialsLineValue
                horizontalAlignment: Text.AlignRight
                text: Number(numTrials).toString()
            }
        }

        Button {
            id: restartButton
            width: comboBoxId.width
            text: qsTr("Restart")
            onClicked: {
                maxTrials: maxTrialsForEasy
                comboBoxIdx: 0
                comboBoxId.currentIndex = comboBoxIdx
                _memoryGame.restartGame()
                restartGame()
            }
        }

        ComboBox {
            id: comboBoxId
            model: ["Easy", "Medium", "Hard"]
            currentIndex: comboBoxIdx
            onCurrentIndexChanged: {
                switch(currentIndex) {
                    case 0:
                        maxTrials = maxTrialsForEasy;
                        break;
                    case 1:
                        maxTrials = maxTrialsForMedium;
                        break;
                    case 2:
                        maxTrials = maxTrialsForHard;
                        break;
                }
            }
        }

        Button {
            id: instrucetionsButton
            width: comboBoxId.width
            text: qsTr("Instructions")
            onClicked: {
                instructionPopup.open()
            }
        }
    }


    /* Main Game Area which consists of Rectangles embedded within Rectangle to from 5*5 Boxes */
    Rectangle {
        id: outterRectangle
        anchors {
            left: parent.left
            right: parent.right
            rightMargin: 170
            verticalCenter: parent.verticalCenter
        }
        width: parent.width - 70
        height: parent.height
        color: "grey"
        border.color: "black"
        border.width: 2

        Column {
            id: rectangleColumn
            spacing: 5
            anchors.top: outterRectangle.top
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            Repeater {
                id: rectangleColumnRepeater
                model: modelRows.count
                delegate: Row {
                    leftPadding: 5
                    rightPadding: 5
                    spacing: 5
                    property int colIndex: index
                    Repeater {
                        id: innerRectangleRow
                        model: modelRows.get(index).rowModel()
                        delegate: Rectangle {
                            id: innerRectangle
                            property bool alphabetVisible: false
                            width: outterRectangle.width / 5 - 6
                            height: outterRectangle.height / 5 - 6
                            border.width: 1
                            property bool isAlphabetStateVisible: internalState === MemoryGame.INTERNAL_STATE_VISIBLE
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: isAlphabetStateVisible ? "light blue" : "#a4bfef" }
                                GradientStop { position: 0.5; color: isAlphabetStateVisible ? "light blue" : "#3791e5" }
                                GradientStop { position: 1.0; color: isAlphabetStateVisible ? "light blue" : "#1b60a0" }
                            }
                            states: State {
                                name: "rectangleGreyed"
                                when: internalState === MemoryGame.INTERNAL_STATE_GREYED
                                PropertyChanges {
                                    target: innerRectangle
                                    gradient: undefined
                                    color: "transparent"
                                }
                            }

                            Text {
                                id: innerRectangleText
                                anchors.centerIn: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: alphabet
                                font.pixelSize: parent.height
                                color: "white"
                                visible: isAlphabetStateVisible
                            }

                            MouseArea {
                                id: rectangleMouseArea
                                anchors.fill: parent
                                enabled: internalState === MemoryGame.INTERNAL_STATE_NEW && _memoryGame.acceptMouseEvents
                                onPressed: {
                                    curColIdx = colIndex
                                    curRowIdx = index
                                    _memoryGame.acceptMouseEvents = false
                                    _memoryGame.setMatchedIndex(colIndex, index, innerRectangleText.visible, alphabet)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onAlphabetStateChanged: {
        modelRows.get(curColIdx).rowModel().setProperty(curRowIdx, "internalState", alphabetState)
        if(_memoryGame.getPeviousAlphabet() !== "" && alphabetState !== MemoryGame.INTERNAL_STATE_VISIBLE)
        {
            modelRows.get(prevColIdx).rowModel().setProperty(prevRowIdx, "internalState", alphabetState)
            _memoryGame.resetPreviousIndex()
        }
    }

    onNumTrialsChanged: {
        if(numTrials > maxTrials) {
            resultsPopup.open()
        }
    }

    onNumMatchedChanged: {
        if(numMatched >= maxMatchedPoints) {
            resultsPopup.open()
        }
    }

    function restartGame() {
        for(var col = 0; col < modelRows.count; col++) {
            for(var row = 0; row < modelRows.get(col).rowModel().count; row++) {
                modelRows.get(col).rowModel().setProperty(row, "internalState", MemoryGame.INTERNAL_STATE_NEW)
            }
        }
    }


    /* Popup to display Instaructions when Instructions Button is pressed */
    Popup {
        id: instructionPopup
        anchors.centerIn: parent
        width: 500
        height: 300
        modal: true
        focus: true
        contentItem: Text {
            width: parent.width
            wrapMode: Text.WordWrap
            text: "Instructions : \n
 1. In total you have 40 Trials for Easy, 30 Trials for Medium, 20 for Hard \n
 2. Matched point is considered when 2 cards are pressed and have same Alphabet \n
 3. When 2 cards are not Matched, they are reclosed and you have to remember and try getting Matched \n
 4. Press Restart to Start Game from Beginning"
        }
    }

    /* Popup to display the Results after Maximum Trials is exceeded or all Cards are Matched */
    Popup {
        id: resultsPopup
        anchors.centerIn: parent
        width: 500
        height: 300
        modal: true
        focus: true
        contentItem: Text {
            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "Results: \n
 1. Total Matched : " + Number(numMatched).toString() + " \n
 2. Total Trials  : " + Number(numTrials).toString()
        }

        onClosed: {
            _memoryGame.acceptMouseEvents = false
        }
    }

}
