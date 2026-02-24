# HTML Vault — App Spec

## What it is
A personal web app for storing and browsing self-contained HTML snippets. Each snippet is a single HTML file pasted in, stored in a database, and served live at its own URL.

## Tech Stack
- **Ruby** with **Sinatra** for routing
- **ActiveRecord** with **SQLite** (via `sinatra-activerecord` gem)
- **ERB** for templates
- **Vanilla CSS** — no framework, good practice

---

## Database

One table: `snippets`

| column | type | notes |
|---|---|---|
| `title` | string | required |
| `slug` | string | unique, URL-safe version of title e.g. `my-timer` |
| `html_content` | text | the raw pasted HTML |
| `tags` | string | comma-separated, e.g. `"tools,timers,fun"` |
| `created_at` | datetime | auto |
| `updated_at` | datetime | auto |

---

## Routes

| method | path | what it does |
|---|---|---|
| GET | `/` | homepage, shows all snippets as cards |
| GET | `/new` | the paste/store form |
| POST | `/snippets` | saves a new snippet, redirects to `/` |
| GET | `/s/:slug` | renders the snippet's raw HTML directly |
| GET | `/s/:slug/edit` | edit form |
| POST | `/s/:slug` | update a snippet |
| DELETE | `/s/:slug` | delete a snippet |

---

## Pages

### Homepage `/`
- Search bar at the top — filters cards by title or tag as you type (can be simple JS on the client side, no need for a server round trip)
- Grid of snippet cards, each showing:
  - Title
  - Tags
  - A scaled-down live preview using an `<iframe>` pointing at `/s/:slug`
  - Edit and Delete buttons
- One big "New Snippet" button

### New/Edit Form
- `Title` text input
- `Tags` text input (comma separated, keep it simple)
- A large `textarea` for pasting the HTML
- A live preview pane next to it — as you paste/type in the textarea, an iframe updates to show the render (use JS `srcdoc` attribute on the iframe)
- Save button

### Snippet page `/s/:slug`
- Just renders the raw `html_content` directly, nothing else — no layout wrapper

---

## Model

The `Snippet` model should handle:
- Auto-generating the slug from the title on save (before_save callback) — strip non-alphanumeric characters, downcase, replace spaces with hyphens
- A `tag_list` helper method that returns tags as an array by splitting on commas
- Validations: title present, slug unique, html_content present

---

## Stretch goals (do these after the core works)
- Auto-extract the `<title>` tag from pasted HTML and pre-fill the title field using JS
- Tag autocomplete from previously used tags
- Snippet version history (store old html_content blobs before overwriting)
- A `/tags/:tag` route that filters snippets by tag

---

## Gems to look up
- `sinatra`
- `sinatra-activerecord`
- `sqlite3`
- `rake` (for db:migrate tasks)
- `rerun` (for auto-reloading in dev)

---

Start with just the database, one route, and one template. Get a snippet saving and rendering before you touch anything else. Good luck!
