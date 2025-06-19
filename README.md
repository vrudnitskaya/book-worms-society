# Book Worms Society

**Book Worms Society** is a collaborative blogging platform for book lovers. It provides a space for users to share posts about books, literary discussions, and reading experiences.

## Features

- Users can create posts on literary topics (reviews, author spotlights, reading challenges).
- Users can comment, reply, and engage in discussions.
- Posts and comments can be liked.
- Posts can be bookmarked for later.
- Users can follow others to stay updated.
- Personalized profiles with bio and avatar.
- Posts can be tagged; tags can be followed.

---

## Setup Instructions

### Requirements

- Ruby `3.x`
- Rails `~> 8.0.1`
- SQLite3

### 1. Install dependencies

```bash
bundle install
```

### 2. Setup the database

```bash
bin/rails db:create db:migrate db:seed
```

> `db/seeds.rb` includes initial sample data.

### 3. Start the server

```bash
bin/rails server
```
### Running Tests

```bash
bundle exec rspec
```

- Author [Valentina Rudnitskaya](https://github.com/vrudnitskaya)