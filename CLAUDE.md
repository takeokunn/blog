# Blog Repo Guidelines for Claude

## Build Commands

- `npm run lint:secret` - Run secretlint to check for secrets
- `textlint "org/**/*.org"` - Lint org files

## Content Organization

- `org/about.org` - About page
- `org/diary/` - Event reports and personal diary entries
  - Format: `YYYYMMDDHHMMSS-title.org`
  - Contains conference reports, meetup reports, travel logs
- `org/fleeting/` - Quick notes and technical solutions
  - Format: `YYYYMMDDHHMMSS-title.org`
  - Contains technical tips, workarounds, and how-to guides
- `org/permanent/` - Long-form articles and permanent knowledge
  - Format: `YYYYMMDDHHMMSS-title.org`
  - Contains in-depth technical articles, programming concepts, reflections
- `org/poem/` - Personal essays and reflections
  - Format: `YYYYMMDDHHMMSS-title.org`
- `org/private/` - Encrypted personal notes
  - Format: `YYYYMMDDHHMMSS.org.gpg`
- `org/zenn/` - Content for Zenn publishing platform
  - `articles/` - Individual articles for Zenn
    - Format: `YYYYMMDDHHMMSS.org`
  - `books/` - Book content for Zenn

Each file follows org-roam naming convention with a timestamp prefix: `YYYYMMDDHHMMSS-title.org`
