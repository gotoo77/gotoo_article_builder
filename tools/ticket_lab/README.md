# Ticket Lab

Small, isolated SVG ticket generator for Gotoo Article Builder.

It intentionally uses only the Python standard library. No extra package is required.

## Quick start

Generate one ticket:

```bash
python3 tools/ticket_lab/render_ticket.py 001
```

Generate every configured ticket:

```bash
python3 tools/ticket_lab/render_ticket.py --all
```

Generated files are written to:

```text
tools/ticket_lab/out/
```

## Structure

```text
tools/ticket_lab/
├── data/
│   └── tickets.json
├── icons/
│   ├── cat_coffee.svgfrag
│   ├── cat_hearts.svgfrag
│   ├── cat_laying.svgfrag
│   ├── cat_sunglasses.svgfrag
│   └── cat_thumbsup.svgfrag
├── templates/
│   └── ticket.svg
├── render_ticket.py
└── out/
```

## Template model

The SVG template uses simple text placeholders:

```text
{{ ticket_number }}
{{ bg_color }}
{{ line1 }}
{{ line2 }}
...
{{ icon_svg }}
```

Ticket content lives in `data/tickets.json`. Line breaks are explicit on purpose so the visual composition stays predictable.

The icon file is injected as raw SVG. All other values are XML-escaped before insertion.
