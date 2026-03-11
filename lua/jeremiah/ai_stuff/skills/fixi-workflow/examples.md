# Fixi Workflow Examples

## 1) Immediate Filter Refresh + Granular Swap

```html
<form class="filters">
  <select
    name="regions"
    multiple
    fx-action="/dashboard"
    fx-method="GET"
    fx-target="#dashboard-charts"
    fx-swap="outerHTML">
    <option value="na">North America</option>
    <option value="eu">Europe</option>
  </select>
</form>

<div id="dashboard-charts"><!-- server-rendered chart partial --></div>
```

Why:

- `select` defaults to `change` in Fixi, so no submit button is required.
- Only chart container is swapped, preserving filter state.

## 2) Re-render Visuals on `fx:swapped`

```html
<script>
  function renderCharts() {
    // Rebuild chart DOM from current partial payload.
  }

  document.addEventListener("fx:swapped", (evt) => {
    if (evt.detail?.cfg?.target?.id === "dashboard-charts") {
      renderCharts();
    }
  });
</script>
```

Why:

- Hooks into Fixi lifecycle without replacing Fixi request/swap behavior.
- Guard prevents unrelated swaps from triggering rerender.

## 3) Replace In-Flight Requests (latest input wins)

```html
<script>
  document.addEventListener("fx:config", (evt) => {
    evt.detail.cfg.drop = 0;
    evt.detail.requests.forEach((cfg) => cfg.abort());
  });
</script>
```

Use when rapid filter/input changes should always resolve to the most recent selection.

## 4) Intersection Extension Pattern

```html
<script>
  document.addEventListener("fx:init", (evt) => {
    if (evt.target.getAttribute("fx-trigger") === "intersect") {
      const obs = evt.target.__fixi_ob = new IntersectionObserver((entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            obs.unobserve(evt.target);
            evt.target.dispatchEvent(new CustomEvent("intersect"));
            return;
          }
        }
      });
      obs.observe(evt.target);
    }
  });
</script>

<tr fx-action="/items?page=2" fx-trigger="intersect" fx-swap="afterend">
  <td>Loading more...</td>
</tr>
```

Use for lazy load/infinite scroll instead of custom scroll handlers.

## 5) Confirmation Extension

```html
<script>
  document.addEventListener("fx:config", (evt) => {
    const message = evt.target.getAttribute("ext-fx-confirm");
    if (message) evt.detail.cfg.confirm = () => confirm(message);
  });
</script>

<button fx-action="/item/42" fx-method="DELETE" ext-fx-confirm="Delete item?">
  Delete
</button>
```

Use for destructive operations with minimal JS.

## Notes

- Validate behavior against:
  - https://github.com/bigskysoftware/fixi/blob/master/README.md
  - https://github.com/bigskysoftware/fixi/blob/master/fixi.js
