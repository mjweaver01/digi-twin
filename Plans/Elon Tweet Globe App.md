---
title: Elon Tweet Globe — Project Plan
status: planning
created: 2026-06-05
tags: [project, plan, typescript, bun, dataviz]
---

# Elon Tweet Globe

An interactive Bun + TypeScript app that renders a 3D globe with Elon-related companies orbiting it, surfaces live + historical signals (stocks, news, tweet history), and produces an **informed prediction of how many tweets Elon Musk will make today**.

## 1. Goal & Scope

**Core output:** a single number — predicted tweets/day — with a confidence band and a short "why" narrative.

**Supporting experience:** a globe (globe.gl) with orbiting bodies for each company. Each body's appearance encodes its current signal (e.g. stock move, news volume). Clicking a body opens a detail panel.

**Non-goals (v1):** auth, multi-user, mobile-native, real-time X firehose, trading.

## 2. Decisions (locked)

| Area | Decision |
|---|---|
| Runtime / build | **Bun** (server + bundler + test runner) |
| Architecture | **Bun server + frontend** — server holds API keys, fetches + caches, exposes a small JSON API |
| Globe rendering | **globe.gl** (Three.js under the hood) |
| Data sourcing | **Seeded historical tweets** (bundled JSON, periodically refreshed) + **live stocks** + **live news** |
| Prediction model | **ARIMA** time-series forecast + **LLM-assist** adjustment layer |

## 3. Entities

Orbiting bodies (the "Elon sphere"):

- **Tesla** (TSLA) — equity
- **SpaceX** — private; proxy via funding rounds / news sentiment (no ticker)
- **DOGE** (dogecoin) — crypto price
- **xAI / Grok** — private; news + product signals
- **X (Twitter)** — platform context
- **The Boring Company / Neuralink** — minor bodies, news-only

Each entity exposes a normalized **signal object**: `{ id, name, kind: 'equity'|'crypto'|'private', price?, dayChangePct?, newsCount24h, newsSentiment, lastUpdated }`.

## 4. Architecture

```
/elon-tweet-globe
├── src/
│   ├── server/
│   │   ├── index.ts            # Bun.serve(): static + JSON API
│   │   ├── routes/
│   │   │   ├── signals.ts      # GET /api/signals  -> entity signal objects
│   │   │   ├── tweets.ts       # GET /api/tweets/history
│   │   │   └── predict.ts      # GET /api/predict   -> forecast + narrative
│   │   ├── sources/            # adapters per data source
│   │   │   ├── stocks.ts       # live equities/crypto
│   │   │   ├── news.ts         # live news + sentiment
│   │   │   └── tweets.ts       # loads seeded historical dataset
│   │   ├── model/
│   │   │   ├── arima.ts        # time-series forecast
│   │   │   ├── features.ts     # build feature vector from signals
│   │   │   └── llmAdjust.ts    # LLM-assist layer
│   │   └── cache.ts            # TTL cache (in-memory + disk snapshot)
│   ├── client/
│   │   ├── main.ts             # bootstrap
│   │   ├── globe.ts            # globe.gl setup + orbit animation
│   │   ├── orbits.ts           # per-entity orbital params + visual encoding
│   │   ├── panels.ts           # detail panel + prediction card
│   │   └── api.ts              # typed fetch client
│   └── shared/
│       └── types.ts            # shared TS types (signals, forecast, etc.)
├── data/
│   └── tweets-history.json     # seeded historical daily tweet counts
├── public/                     # index.html, textures, styles
├── .env.example
├── package.json
└── README.md
```

**Data flow:** client → `/api/predict` → server builds features from cached signals + tweet history → ARIMA forecast → LLM-assist nudges the point estimate using current-event context → returns `{ point, low, high, narrative, drivers[] }`.

## 5. Data Sources

**Stocks / crypto (live):** Finnhub or Alpha Vantage for TSLA; CoinGecko for DOGE. Free tiers, server-side keys, cache 5–15 min.

**News (live):** a news API (e.g. NewsAPI / GDELT) filtered to Elon + company keywords. Compute `newsCount24h` and a lightweight sentiment score (lexicon or LLM batch). Cache 15–30 min.

**Tweet history (seeded):** `data/tweets-history.json` = `[{ date, count }]` daily totals. Seed from a manually compiled / periodically updated dataset (X API is too costly for live). Document the refresh procedure in the README. This dataset is the training series for ARIMA.

## 6. Prediction Model

**Stage A — ARIMA baseline.**
- Input: daily tweet-count series from the seeded dataset.
- Handle seasonality (day-of-week effects) and recent trend.
- Output: baseline point forecast + prediction interval for today.
- Implementation: a small ARIMA in TS, or shell out to a Python `statsmodels` helper via Bun subprocess if precision matters. Decide during spike (task 7.2).

**Stage B — LLM-assist adjustment.**
- Input: ARIMA baseline + today's signal snapshot (stock moves, news volume/sentiment, notable events).
- The LLM returns a multiplier/delta and a 1–2 sentence rationale, constrained to a sane range (e.g. ±40% of baseline) so it nudges rather than overrides.
- Output merged into final `{ point, low, high, narrative, drivers[] }`.

**Why this split:** ARIMA gives a defensible statistical floor; the LLM injects awareness of current events the time series can't see. Keep both visible in the UI for transparency.

## 7. Build Phases (tasks)

1. **Scaffold** — `bun init`, TS config, shared types, `Bun.serve` static + `/api/health`.
2. **Data spike** — validate stock/news APIs, finalize ARIMA approach (pure TS vs Python subprocess), assemble seed tweet dataset.
3. **Server: sources + cache** — implement `stocks`, `news`, `tweets` adapters + TTL cache; `/api/signals`, `/api/tweets/history`.
4. **Model** — `features`, `arima`, `llmAdjust`; wire `/api/predict`.
5. **Client: globe** — globe.gl scene, orbiting entities, signal-driven visual encoding, animation loop.
6. **Client: panels** — entity detail panel + prediction card (number, band, drivers, narrative).
7. **Polish** — loading/error states, theming, README + refresh docs, `.env.example`.
8. **Verify** — unit tests for feature builder + ARIMA on a known series; backtest predictions vs held-out history; sanity-check LLM bounds; screenshot the globe.

## 8. Risks & Mitigations

- **X data freshness** — no cheap live tweet feed → seeded dataset + documented refresh cadence; be explicit in UI that history is as-of a date.
- **SpaceX/xAI have no ticker** — use news-sentiment proxy; mark as "indirect signal."
- **API rate limits / keys** — aggressive caching + disk snapshot fallback so the app degrades gracefully.
- **LLM overreach** — hard bounds on the adjustment multiplier; always show ARIMA baseline alongside.
- **ARIMA in TS** — if no solid TS lib, fall back to a Python subprocess (decided in task 7.2).

## 9. Stretch ideas

- Backtest view: predicted vs actual over the last N days.
- Per-entity "tweet attribution" heatmap (which company's news days correlate with tweet spikes).
- Scheduled daily snapshot so the globe shows "today's prediction" on load without a cold fetch.

## 10. Open questions

- Which stock + news API tiers (cost vs limits)?
- How often will the seed tweet dataset realistically be refreshed?
- Should the LLM-assist call run server-side per request, or be precomputed in a daily job for speed/cost?
