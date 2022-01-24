#pragma once

#include <QObject>

class MemoryGame : public QObject
{
    Q_OBJECT

    Q_PROPERTY(uint8_t matchedSet READ matchedSet WRITE setMatchedSet NOTIFY matchedSetChanged);
    Q_PROPERTY(uint8_t numTrials READ numTrials WRITE setNumTrials NOTIFY numTrialsChanged);
    Q_PROPERTY(uint8_t previousColIdx READ previousColIdx NOTIFY previousColIdxChanged);
    Q_PROPERTY(uint8_t previousRowIdx READ previousRowIdx NOTIFY previousRowIdxChanged);
    Q_PROPERTY(INTERNAL_STATE alphabetState READ alphabetState WRITE setalphabetState NOTIFY alphabetStateChanged);
    Q_PROPERTY(bool acceptMouseEvents READ acceptMouseEvents WRITE setAcceptMouseEvents NOTIFY acceptMouseEventsChanged);

public:
    MemoryGame() = delete;
    explicit MemoryGame(QObject *parent);
    ~MemoryGame();

    enum class INTERNAL_STATE : uint8_t
    {
        INTERNAL_STATE_NEW = 0,
        INTERNAL_STATE_VISIBLE = 1,
        INTERNAL_STATE_GREYED = 2
    };
    Q_ENUM(INTERNAL_STATE)

    Q_INVOKABLE void setMatchedIndex(uint8_t colIdx, uint8_t rowIdx, bool isAlphabetVisible, QString alphabet);
    Q_INVOKABLE QString getPeviousAlphabet() { return m_previousAlphabet; }
    Q_INVOKABLE void resetPreviousIndex();
    Q_INVOKABLE void restartGame();

    uint8_t matchedSet() { return m_matchedSet; }
    uint8_t numTrials() { return m_numTrials; }
    uint8_t previousColIdx() { return m_previousColIdx; }
    uint8_t previousRowIdx() { return m_previousRowIdx; }
    bool acceptMouseEvents() { return m_acceptMouseEvents; }
    INTERNAL_STATE alphabetState() { return m_alphabetInternalState; }

    void setMatchedSet(uint8_t count) { m_matchedSet = count; }
    void setNumTrials(uint8_t count) { m_numTrials = count; }
    void setAcceptMouseEvents(bool accept) { m_acceptMouseEvents = accept; emit acceptMouseEventsChanged(m_acceptMouseEvents); }
    void setalphabetState(INTERNAL_STATE state) { m_alphabetInternalState = state; }

signals:
    void matchedSetChanged(uint8_t count);
    void numTrialsChanged(uint8_t count);
    void previousColIdxChanged(uint8_t idx);
    void previousRowIdxChanged(uint8_t idx);
    void acceptMouseEventsChanged(bool accept);
    void alphabetStateChanged(MemoryGame::INTERNAL_STATE state);

public slots:
    void setInternalState();

private:
    uint8_t m_previousColIdx = 0;
    uint8_t m_previousRowIdx = 0;
    QString m_previousAlphabet = "";
    uint8_t m_matchedSet = 0;
    uint8_t m_numTrials = 0;
    bool isResetToNew = true;
    bool m_acceptMouseEvents = true;
    INTERNAL_STATE m_alphabetInternalState = INTERNAL_STATE::INTERNAL_STATE_NEW;
};
