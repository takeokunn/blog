# Blog Repository Information

This repository contains a personal blog built with [Hugo](https://gohugo.io/) and uses [org-roam](https://www.orgroam.com/) and [ox-hugo](https://ox-hugo.scripter.co/) for content generation in a Zettelkasten style.

## Repository Structure

- **content/**: Contains the blog posts and pages
- **static/**: Static assets like images, CSS, and JavaScript
- **themes/**: Contains the Hugo theme (using a custom theme: hugo-take-theme)
- **org/**: Contains org-mode files used for content generation
- **archetypes/**: Templates for new content
- **zenn/**: Content for publishing on Zenn platform
- **typst/**: Typst documents
- **scripts/**: Utility scripts for the blog

## Development

To run the blog locally:

```bash
# Install Hugo
# Run the Hugo server
hugo server -D --port 52112 --bind 0.0.0.0 --disableFastRender
```

## Publishing

The blog is published to:
- Main site: https://takeokunn.org (GitHub Pages)
- Zenn: https://zenn.dev/takeokunn

## Theme

The blog uses a custom theme: [takeokunn/hugo-take-theme](https://github.com/takeokunn/hugo-take-theme)

To update the theme:
```bash
git submodule update --remote --recursive
```