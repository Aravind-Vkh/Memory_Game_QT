#include "memoryGame.h"
#include <qdebug.h>
#include <qtimer.h>

MemoryGame::MemoryGame(QObject *parent)
    : QObject(parent)
{
    qDebug() << __FUNCTION__ << " Constructor";
}

MemoryGame::~MemoryGame()
{
}

/* Function to perform arbitration in the backend and take decision point whether previous Alphabet is same as New Set */
void MemoryGame::setMatchedIndex(uint8_t colIdx, uint8_t rowIdx, bool isAlphabetVisible, QString alphabet)
{
    qDebug() << __FUNCTION__ << "setMatchedIndex Called : " << colIdx << " - " << rowIdx << " - " << isAlphabetVisible << " - " << alphabet;
    if(m_previousAlphabet.isEmpty())
    {
        m_previousAlphabet = alphabet;
        m_previousColIdx = colIdx;
        m_previousRowIdx = rowIdx;
        m_alphabetInternalState = INTERNAL_STATE::INTERNAL_STATE_VISIBLE;
        m_acceptMouseEvents = true;
        emit previousColIdxChanged(m_previousColIdx);
        emit previousRowIdxChanged(m_previousRowIdx);
        emit alphabetStateChanged(m_alphabetInternalState);
        emit acceptMouseEventsChanged(m_acceptMouseEvents);
    }
    else
    {
        qDebug() << __FUNCTION__ << "Previous Alphabet : " << m_previousAlphabet << " - Prev Set : " << colIdx << " - " << rowIdx;
        if(m_previousAlphabet == alphabet)
        {
            m_matchedSet++;
            m_alphabetInternalState = INTERNAL_STATE::INTERNAL_STATE_VISIBLE;
            isResetToNew = false;
            emit matchedSetChanged(m_matchedSet);
            emit alphabetStateChanged(m_alphabetInternalState);
            QTimer::singleShot(1000, this, SLOT(setInternalState()));
        }
        else
        {
            m_alphabetInternalState = INTERNAL_STATE::INTERNAL_STATE_VISIBLE;
            isResetToNew = true;
            emit alphabetStateChanged(m_alphabetInternalState);
            QTimer::singleShot(1000, this, SLOT(setInternalState()));
        }
        m_numTrials++;
        emit numTrialsChanged(m_numTrials);
    }
}

/* Function to Set the Internal State of the Individual Alphabet */
void MemoryGame::setInternalState()
{
    if(isResetToNew)
    {
        m_alphabetInternalState = INTERNAL_STATE::INTERNAL_STATE_NEW;
    }
    else
    {
        m_alphabetInternalState = INTERNAL_STATE::INTERNAL_STATE_GREYED;
        isResetToNew = true;
    }
    m_acceptMouseEvents = true;
    emit alphabetStateChanged(m_alphabetInternalState);
    emit acceptMouseEventsChanged(m_acceptMouseEvents);
}

/* Function to Reset the Previous Column and Row Index */
void MemoryGame::resetPreviousIndex()
{
    m_previousAlphabet = "";
    m_previousRowIdx = 0;
    m_previousColIdx = 0;
    emit previousColIdxChanged(m_previousColIdx);
    emit previousRowIdxChanged(m_previousRowIdx);
}

/* Function to Reset the local contents and emit Individual Signals to update the UI Accordingly */
void MemoryGame::restartGame()
{
    m_previousAlphabet = "";
    m_previousRowIdx = 0;
    m_previousColIdx = 0;
    m_matchedSet = 0;
    m_numTrials = 0;
    isResetToNew = true;
    m_acceptMouseEvents = true;
    m_alphabetInternalState = INTERNAL_STATE::INTERNAL_STATE_NEW;
    emit previousColIdxChanged(m_previousColIdx);
    emit previousRowIdxChanged(m_previousRowIdx);
    emit matchedSetChanged(m_matchedSet);
    emit numTrialsChanged(m_numTrials);
    emit alphabetStateChanged(m_alphabetInternalState);
    emit acceptMouseEventsChanged(m_acceptMouseEvents);
}
