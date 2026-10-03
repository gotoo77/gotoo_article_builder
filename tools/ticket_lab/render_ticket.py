#!/usr/bin/env python3
from __future__ import annotations

import argparse
import html
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DATA_FILE = ROOT / "data" / "tickets.json"
TEMPLATE_FILE = ROOT / "templates" / "ticket.svg"
ICONS_DIR = ROOT / "icons"
OUT_DIR = ROOT / "out"

PLACEHOLDER_RE = re.compile(r"{{\s*([A-Za-z0-9_]+)\s*}}")


def load_config() -> dict:
    with DATA_FILE.open(encoding="utf-8") as fh:
        return json.load(fh)


def render(template: str, values: dict[str, str]) -> str:
    missing = sorted(set(PLACEHOLDER_RE.findall(template)) - set(values))
    if missing:
        raise ValueError(f"missing template values: {', '.join(missing)}")

    def replace(match: re.Match[str]) -> str:
        key = match.group(1)
        value = str(values[key])
        if key == "icon_svg":
            return value.rstrip()
        return html.escape(value, quote=True)

    return PLACEHOLDER_RE.sub(replace, template)


def ticket_context(defaults: dict, ticket: dict) -> dict[str, str]:
    values = {**defaults, **ticket}

    icon_name = values.pop("icon", None)
    if not icon_name:
        raise ValueError(f"ticket {ticket.get('ticket_number', '?')}: missing icon")

    icon_path = ICONS_DIR / icon_name
    if not icon_path.is_file():
        raise ValueError(f"ticket {ticket.get('ticket_number', '?')}: icon not found: {icon_path}")

    values["icon_svg"] = icon_path.read_text(encoding="utf-8")
    return {key: str(value) for key, value in values.items()}


def find_ticket(tickets: list[dict], number: str) -> dict:
    normalized = number.zfill(3)
    for ticket in tickets:
        if str(ticket.get("ticket_number", "")).zfill(3) == normalized:
            return ticket
    raise ValueError(f"unknown ticket number: {number}")


def write_ticket(template: str, defaults: dict, ticket: dict) -> Path:
    context = ticket_context(defaults, ticket)
    number = context["ticket_number"].zfill(3)
    output = OUT_DIR / f"ticket_{number}.svg"
    output.write_text(render(template, context), encoding="utf-8")
    return output


def main() -> int:
    parser = argparse.ArgumentParser(description="Render customizable SVG tickets.")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("ticket", nargs="?", help="ticket number, for example 001")
    group.add_argument("--all", action="store_true", help="render all configured tickets")
    args = parser.parse_args()

    try:
        config = load_config()
        defaults = config.get("defaults", {})
        tickets = config.get("tickets", [])
        template = TEMPLATE_FILE.read_text(encoding="utf-8")

        OUT_DIR.mkdir(parents=True, exist_ok=True)

        selected = tickets if args.all else [find_ticket(tickets, args.ticket)]

        for ticket in selected:
            output = write_ticket(template, defaults, ticket)
            print(output.relative_to(ROOT.parent.parent))

        return 0
    except (OSError, json.JSONDecodeError, ValueError) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
