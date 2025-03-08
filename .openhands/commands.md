# Useful Commands

## Hugo Commands

```bash
# Start the Hugo server for local development
hugo server -D --port 52112 --bind 0.0.0.0 --disableFastRender

# Build the site
hugo

# Create a new post
hugo new posts/my-new-post.md
```

## Git Commands

```bash
# Update the theme submodule
git submodule update --remote --recursive

# Initialize submodules (if needed)
git submodule init
git submodule update
```

## Node.js Commands

```bash
# Install dependencies
npm install

# Run secret linting
npm run lint:secret
```

## Content Generation

```bash
# If using org-mode and ox-hugo, export org files to Hugo markdown
# This would typically be done from within Emacs
```

## Deployment

The site is deployed to GitHub Pages. The deployment process is likely handled through GitHub Actions or similar CI/CD pipeline.