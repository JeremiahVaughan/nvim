---
name: fixi-workflow
description: Applies Fixi-first UI patterns using fx-action, fx-target, fx-swap, fx-trigger, and lifecycle events like fx:swapped. Use when building partial swaps, filter-driven refreshes, inline lifecycle-hook JavaScript, or when the user mentions Fixi/fixi.js.
---

# Fixi Workflow

## Purpose

Use Fixi as the default mechanism for request + swap behavior. Add custom JavaScript only when reacting to Fixi lifecycle events is necessary.

## Canonical References

Always treat these as primary references:

- Fixi README: https://github.com/bigskysoftware/fixi/blob/master/README.md
- Fixi source: https://github.com/bigskysoftware/fixi/blob/master/fixi.js

Reference rule:

- Use README for documented attributes, events, and extension patterns.
- Use `fixi.js` for exact runtime behavior (default trigger selection, `FX-Request` header, swap mechanics, request dropping, event dispatch order).

## Core Rules

1. Prefer declarative `fx-*` attributes before writing JS.
2. Use narrow swap targets to preserve local UI state.
3. Keep swapped responses server-rendered and scoped to one region when possible.
4. For controls like `select`, rely on default Fixi triggers unless an explicit trigger is needed.
5. Keep lifecycle JS small, local, and single-purpose.

## Fixi-First Workflow

1. Identify interaction target (form/control/button).
2. Wire request via `fx-action` (+ `fx-method` when needed).
3. Choose precise `fx-target`.
4. Choose minimal `fx-swap` behavior for state preservation.
5. Only if needed, add lifecycle hook JS (`fx:swapped`, `fx:config`, `fx:after`).
6. Verify no custom fetch/event stack duplicates Fixi behavior.

## Lifecycle JS Boundaries

Allowed:

- Re-render chart/visual after swap using `fx:swapped`.
- Adjust request config in `fx:config` (headers, drop behavior, confirm).
- Post-process response text in `fx:after`.

Avoid:

- Replacing Fixi request lifecycle with manual `fetch()` for standard interactions.
- Unscoped document listeners that rerender unrelated regions.
- Large utility scripts for behavior already represented by Fixi attributes/events.

## Canonical Pattern: Filter-Driven Refresh

- Keep filter controls outside swapped chart/content container.
- Trigger refresh immediately on control interaction (no separate submit button).
- Swap only the chart/content container.
- Re-render visuals in `fx:swapped`, guarded by `evt.detail.cfg.target`.

## Recommended README Extensions

Use these before inventing custom JS:

1. **Intersection Events (`fx-trigger="intersect"`)**
   - Use for lazy loading and infinite scroll.
   - Avoid for simple click/submit flows.

2. **Debounce Extension (`ext-fx-debounce`)**
   - Use for high-frequency input events (search/typeahead).
   - Avoid if server latency is low and event volume is small.

3. **Replace In-Flight Requests (`fx:config`)**
   - Use for rapid control changes where latest selection should win.
   - Pattern: `cfg.drop = 0` then abort existing requests.

4. **Confirmation Extension (`ext-fx-confirm`)**
   - Use for destructive actions.
   - Keep confirmation logic simple and user-visible.

5. **Indicator/Disable Extensions**
   - Use `fx:before`/`fx:after` to reflect loading state.
   - Keep behavior local to the initiating element/target.

6. **Relative Selectors for `fx-target`**
   - Use when a static selector is awkward and target is context-dependent.
   - Avoid overuse if a stable id/class target is available.

## Anti-Patterns

- Broad page swaps that reset user-entered or selected values.
- Manual request orchestration where `fx-action` + attributes suffice.
- Reimplementing README extensions with bespoke JS without a clear reason.
- Embedding large client state machinery for server-rendered partial flows.

## Implementation Checklist

- [ ] Fixi attributes cover request + swap behavior.
- [ ] Swap target is granular and state-safe.
- [ ] Lifecycle hook JS is short and scoped.
- [ ] README/source behavior assumptions were checked.
- [ ] No duplicated behavior from existing README extensions.

## Examples

For concrete snippets, see [examples.md](examples.md).
