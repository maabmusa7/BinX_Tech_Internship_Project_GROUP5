# Speech-to-Text & Pronunciation Scoring

STT module for the AI/ML service. Converts user speech to text, then scores pronunciation quality per word — built on a frozen WhisperX model (no fine-tuning), with a lightweight classifier trained on top of its alignment features.

## Model & Approach

- **STT:** WhisperX "small" — audio → transcript
- **Pronunciation scoring:** WhisperX forced alignment (character-level) → 4 features (mean/min/std/range of char scores) → Logistic Regression classifier (threshold = 0.62)
- Evaluated on speechocean762: **F1 = 0.31** on test set (vs 0.25 for a raw-confidence baseline)
- ~10% of words in the dataset are true pronunciation issues (class imbalance), so Precision/Recall were used instead of raw accuracy

## How to Use

Two functions, chained together:

```python
transcript = transcribe(audio_array, transcribe_model)

result = score_pronunciation(
    audio_array, sample_rate, transcript,
    align_model, align_metadata, classifier, device
)
```

Or call both at once:

```python
result = process_audio_turn(
    audio_array, sample_rate,
    transcribe_model, align_model, align_metadata, classifier, device
)
```

## Output Format

```json
{
  "transcript": "I think this is good",
  "pronunciation": {
    "words": [
      {"word": "I", "confidence": 0.12, "flag": "ok"},
      {"word": "think", "confidence": 0.71, "flag": "needs_attention"},
      {"word": "this", "confidence": 0.09, "flag": "ok"}
    ]
  }
}
```

| Field | Meaning |
|---|---|
| `transcript` | Full text recognized from the audio |
| `pronunciation.words[].word` | The word |
| `pronunciation.words[].confidence` | Probability (0-1) that this word has a pronunciation issue |
| `pronunciation.words[].flag` | `"ok"` or `"needs_attention"` (threshold = 0.62) |

If alignment fails, returns `{"words": [], "warning": "alignment_failed"}` instead of crashing.

## Performance

- Latency: ~0.2s per request (STT ~0.12s, scoring ~0.07s)
- GPU: <0.5GB VRAM

## Notebooks

- `whisperx_pronounciation.ipynb` — dataset exploration, raw alignment score baseline
- `char_features_v2.ipynb` — final model training (char features + classifier)
- `pipeline_functions.ipynb` — deployable functions + performance tests
