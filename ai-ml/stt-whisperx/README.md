# STT + Pronunciation Scoring (WhisperX)
AI/ML track — the module that turns the learner's recorded speech into text and flags which words may have been mispronounced.

## Model: WhisperX

WhisperX is used as a **frozen pretrained model** — no training or fine-tuning from scratch.

**Why WhisperX:**
- Returns a transcript **plus per-word confidence scores and timestamps** out of the box — exactly the signal needed to flag individual words
- Mature, well-documented tooling; fast to set up within the project's 7-day timeline
- Per mentor guidance, fine-tuning was skipped in favour of evaluating a pretrained model, given time and compute constraints

**Trade-off:** feedback is at the **word level** ("this word may be off"), not the phoneme level ("the 'th' sound specifically was wrong"). Phoneme-level scoring (e.g. Wav2Vec2 + ARPAbet alignment) was considered but ruled out as too costly for the available time.

## Datasets

| Dataset | Role |
|---|---|
| **speechocean762** | Primary dataset. Non-native English speakers with human-annotated pronunciation scores at sentence, word, and phoneme level. Used for EDA and for calibrating the confidence threshold. |
| **L2-ARCTIC** | Secondary check. Non-native speakers across several first languages (incl. Arabic) — used to see whether performance holds beyond speechocean762's Mandarin-only speakers. |
| **Common Voice** | Sanity check only. Diverse general English, used to confirm the model still performs reasonably on everyday speech. |

Full EDA is performed on **speechocean762 only**, since it is the dataset the threshold decision is based on. The other two are used for quick performance checks, not for decision-making.

## Approach

1. **EDA** on speechocean762 — data quality, score distributions, audio format
2. **Run WhisperX** on the audio, extract per-word confidence
3. **Calibrate a threshold** by comparing confidence against human word-level accuracy scores
4. **Output** a JSON contract (transcript + per-word confidence + flag) for the LLM/feedback track

## Note on evaluation metrics

Word-level accuracy in the dataset is heavily imbalanced — roughly 90% of words are scored perfect. Plain accuracy would therefore be misleading, so **Precision and Recall** are used instead, treating mispronounced words as the positive class.

