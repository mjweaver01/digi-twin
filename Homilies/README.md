# Homilies

Homilies distilled from favorited Philosophizer conversations. Each file is a cohesive, standalone homily — the message itself, not a recap of the conversation — with scripture and sources woven in. The source conversation (title, date, and ID for tracing back to the Philosophizer database) is noted in a footer at the bottom of each file.

## Index

| Homily | Source Conversation | Date |
|---|---|---|
| [The School of Ascent: Why the Infinite Meets Us in a Finite World](2026-04-03-foreknowledge-and-freedom.md) | if god knows all, why does he choose for us to operate under free will | 2026-04-03 |
| [Tremble and Stay: The Still, Dark Center of History](2026-04-03-good-friday.md) | today is good friday - dig deep on it | 2026-04-03 |
| [The Day the Universe Changed Its Mind About Death](2026-04-05-easter-sunday-deep-dive.md) | Today is Easter Sunday - dig deep on it | 2026-04-05 |
| [The Name Spoken in the Garden: An Easter Sunday of Sacred Reading](2026-04-05-easter-sunday-overview.md) | Today is Easter Sunday - can you give me an overview... | 2026-04-05 |
| [The Veil Lifted: Reading Scripture as an Encounter, Not a Conquest](2026-04-05-how-to-read-the-bible.md) | How should I read the Bible? | 2026-04-05 |
| [Eternity in a Heart of Seasons](2026-06-20-a-time-for-everything.md) | elaborate on the ecclesiastes verse of time and a season | 2026-06-20 |
| [The Restless Heart and the Open Door](2026-06-20-augustine-before-christ.md) | tell me about st augustine before he found christ | 2026-06-20 |
| [Beautiful in Its Time: The Artistry of God and the Eternity in Our Hearts](2026-06-20-beautiful-in-its-time.md) | elaborate on "He has made everything beautiful in its time" | 2026-06-20 |
| [The Spring That Flows Outward: Love as Self-Donation](2026-06-20-love-is-a-giving-thing.md) | "love is a giving thing" elaborate on that | 2026-06-20 |
| [The Debt That Is Never Paid](2026-06-20-owe-no-man-but-love.md) | elaborate on "owe no man but love" | 2026-06-20 |
| [Every Babylon Falls: The Beast, the Harlot, and the Two Cities](2026-06-20-the-beast-of-revelation.md) | can you elaborate on in revelation the beast and babylon | 2026-06-20 |
| [The Name That Is: Four Letters and the Ground of Being](2026-06-20-the-tetragrammaton.md) | lets dive deep about the tetragrammaton | 2026-06-20 |
| [The War Begins in the Mind: Taking Every Thought Prisoner](2026-06-20-thoughts-into-captivity.md) | can you elaborate on "bring all thoughts into captivity" | 2026-06-20 |
| [The Word and the Wave: A Universe Spoken in Light](2026-06-30-everything-is-made-of-light.md) | expound of my thought - if everything is made of light... | 2026-06-30 |

## Extracting more

Favorite a conversation in the app, then pull its transcript from the dockerized database:

```bash
docker exec philosophizer-postgres psql -U postgres -d philosophizer -c \
  "SELECT role, content FROM conversation_messages WHERE conversation_id = '<id>' ORDER BY created_at;"
```
