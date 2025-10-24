# System Design Journey

A personal learning journey documenting my exploration of FAANG-level system design concepts.

## About

This repository contains my daily learning logs, system design notes, and practice problems as I work through a comprehensive system design curriculum.

## Live Site

Visit the live documentation: [system-design-journey](https://hawaijar.github.io/System-Design-Journey)

## Local Development

### Setup

1. Clone the repository:
```bash
git clone https://github.com/hawaijar/System-Design-Journey.git
cd System-Design-Journey
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

### Running Locally

To preview the site locally:

```bash
mkdocs serve
```

Then visit `http://127.0.0.1:8000` in your browser.

### Building the Site

To build the static site:

```bash
mkdocs build
```

## Project Structure

```
.
├── docs/
│   ├── index.md              # Home page
│   ├── daily/                # Daily learning logs
│   │   └── index.md
│   ├── topics/               # Organized by topic
│   │   └── index.md
│   ├── resources.md          # Learning resources
│   └── about.md              # About the project
├── mkdocs.yml                # MkDocs configuration
├── requirements.txt          # Python dependencies
└── README.md                 # This file
```

## Adding Content

### Daily Log Entry

Create a new file in `docs/daily/` following the template in `docs/daily/index.md`.

Example: `docs/daily/2024-10-24.md`

### Topic Page

Add topic-specific pages in `docs/topics/` and update the navigation in `mkdocs.yml`.

## Deployment

This site is automatically deployed to GitHub Pages using GitHub Actions.

To deploy manually:

```bash
mkdocs gh-deploy
```

## License

This is a personal learning repository. Feel free to use the structure for your own learning journey.
