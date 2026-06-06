# Chess Notation

Chess notation is the language used to record and read chess moves. Once you learn it, you can follow along with any game, study openings from books, and analyze your own games.

The standard system is called **Algebraic Notation**.

---

## The Board

- **Files** (columns) are labeled **a–h** left to right (from White's perspective)
- **Ranks** (rows) are labeled **1–8** bottom to top (from White's perspective)
- Every square has a unique coordinate: **file + rank** (e.g., e4, d5, g7)

```
8  [ ][ ][ ][ ][ ][ ][ ][ ]
7  [ ][ ][ ][ ][ ][ ][ ][ ]
6  [ ][ ][ ][ ][ ][ ][ ][ ]
5  [ ][ ][ ][ ][ ][ ][ ][ ]
4  [ ][ ][ ][X][ ][ ][ ][ ]   ← X = e4
3  [ ][ ][ ][ ][ ][ ][ ][ ]
2  [ ][ ][ ][ ][ ][ ][ ][ ]
1  [ ][ ][ ][ ][ ][ ][ ][ ]
    a  b  c  d  e  f  g  h
```

---

## Piece Letters

| Symbol | Piece |
|--------|-------|
| K | King |
| Q | Queen |
| R | Rook |
| B | Bishop |
| N | Knight (K is taken!) |
| *(nothing)* | Pawn |

---

## Writing a Move

Format: **[Piece][Destination square]**

- `e4` — a pawn moves to e4
- `Nf3` — Knight moves to f3
- `Bc4` — Bishop moves to c4
- `Qd1` — Queen moves to d1

### Captures
Add an **x** between piece and destination:
- `Nxe5` — Knight captures on e5
- `exd5` — pawn on e-file captures on d5 (for pawn captures, include the file the pawn came from)

### Check and Checkmate
- `+` after a move = check (e.g., `Bb5+`)
- `#` after a move = checkmate (e.g., `Qh7#`)

### Castling
- `O-O` = Kingside castling (short)
- `O-O-O` = Queenside castling (long)

### Pawn Promotion
- `e8=Q` — pawn moves to e8 and promotes to Queen

### Disambiguation
If two of the same piece can move to the same square, add the file or rank of the piece moving:
- `Nbd2` — the Knight on the b-file moves to d2 (not the other one)
- `R1e4` — the Rook on rank 1 moves to e4

---

## Game Notation Format

Moves are numbered, White first then Black:

```
1. e4   e5
2. Nf3  Nc6
3. Bc4  Bc5
4. O-O  Nf6
```

This is the Italian Game opening. You can read any chess book, website, or database using this format.

---

## Annotation Symbols

These appear in analyzed games to mark quality of moves:

| Symbol | Meaning |
|--------|---------|
| ! | Good move |
| !! | Brilliant move |
| ? | Mistake |
| ?? | Blunder (serious mistake) |
| !? | Interesting move, possibly risky |
| ?! | Dubious move |

---

## Practice

The best way to get comfortable with notation is to:
1. Turn on "show notation" in Lichess or Chess.com as you play
2. Try to write down your moves during casual games
3. Read through any famous game (e.g., The Immortal Game: Anderssen vs Kieseritzky, 1851)

---

## See Also
- [[The Pieces]] — what each letter refers to
- [[Openings]] — opening sequences written in notation
