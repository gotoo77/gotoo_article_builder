# Gotoo Article Builder

Minimal Markdown-to-HTML article builder for clean, styled, self-contained articles.

The project deliberately keeps the pipeline small:

```text
article.md
    |
    v
./build.sh article.md
    |
    v
dist/article.html
```

## Requirements

- `pandoc`
- POSIX shell

On Debian/Ubuntu:

```bash
sudo apt install pandoc
```

On Fedora:

```bash
sudo dnf install pandoc
```

## Quick start

```bash
./build.sh examples/attention/article.md
```

The generated file is:

```text
dist/article.html
```

It is a standalone HTML document. CSS and referenced local assets are embedded by Pandoc.

## Writing an article

Use normal Markdown plus YAML metadata:

```md
---
title: "My article"
subtitle: "Optional subtitle"
date: 2026-10-03
author: Gotoo
---

# First section

Text with [a link](https://example.org).

> A quotation or highlighted thought.

::: punchline
A short sentence worth emphasizing.
:::

![An image](assets/image.png)
```

## Scope

The first version intentionally does not provide a CMS, JavaScript framework, server, database or static-site generator.

The goal is one reliable transformation:

```text
Markdown + assets -> polished standalone HTML
```
