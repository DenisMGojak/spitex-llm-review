defmodule MegalithWeb.Components.FilterPanel do
  @moduledoc """
  Filter panel — collapses choice filters (Domain / Priority / Status) behind a
  single button + active-filter badges.

  Parent LV owns `:open` state via `assign(:filter_panel_open, false)` and toggles
  via the `"toggle_filter_panel"` event. Filters are set via `"set_filter"` with
  `phx-value-key={key}` + `phx-value-value={value}`, removed via `"remove_filter"`,
  and reset via `"reset_filters"`.
  """

  use MegalithWeb, :html

  @filter_choices %{
    source_domain: [
      {:all, "All"},
      {:work, "Work"},
      {:crm, "CRM"},
      {:projects, "Projects"},
      {:ageops, "AgeOps"}
    ],
    priority: [
      {:all, "All"},
      {:low, "Low"},
      {:medium, "Medium"},
      {:high, "High"},
      {:urgent, "Urgent"}
    ],
    status: [
      {:all, "All"},
      {:open, "Open"},
      {:in_progress, "In Progress"},
      {:done, "Done"}
    ]
  }

  attr :filters, :map,
    required: true,
    doc: "map %{source_domain: atom, priority: atom, status: atom}"

  attr :open, :boolean, default: false

  attr :visible_keys, :list,
    default: [:source_domain, :priority, :status],
    doc: "Which choice filters to show in the dropdown"

  def filter_panel(assigns) do
    ~H"""
    <div id="filter-panel" class="relative inline-flex flex-wrap items-center gap-1">
      <%!-- Toggle button --%>
      <button
        type="button"
        id="filter-panel-toggle"
        phx-click="toggle_filter_panel"
        aria-haspopup="menu"
        aria-expanded={to_string(@open)}
        class={[
          "inline-flex items-center gap-1 rounded-md px-2.5 py-1.5 text-xs font-medium transition-colors",
          @open && "ring-2 ring-[var(--grok-accent)]"
        ]}
        style={
          if @open,
            do: "background: var(--grok-accent); color: white;",
            else: "background: var(--grok-bg-secondary); color: var(--grok-text-primary);"
        }
      >
        <span>⚙ Filters</span>
        <span :if={active_count(@filters, @visible_keys) > 0}>
          ({active_count(@filters, @visible_keys)})
        </span>
        <span class="text-[var(--grok-text-tertiary)]" style={if @open, do: "color: white;"}>
          {if @open, do: "▴", else: "▾"}
        </span>
      </button>

      <%!-- Active filter badges (shown when panel is closed) --%>
      <%= for key <- @visible_keys, not @open, active?(Map.get(@filters, key)) do %>
        <span
          id={"filter-panel-badge-#{key}"}
          class="inline-flex items-center gap-1 rounded-md px-2 py-1 text-xs"
          style="background: var(--grok-accent); color: white;"
        >
          <span>{filter_label(key)}: {choice_label(key, Map.get(@filters, key))}</span>
          <button
            type="button"
            id={"filter-panel-badge-remove-#{key}"}
            phx-click="remove_filter"
            phx-value-key={to_string(key)}
            aria-label={"Remove #{filter_label(key)} filter (current: #{choice_label(key, Map.get(@filters, key))})"}
            class="ml-0.5 rounded-full px-1 text-xs transition-colors hover:bg-white/20"
          >
            ×
          </button>
        </span>
      <% end %>

      <%!-- Dropdown panel --%>
      <div
        :if={@open}
        id="filter-panel-dropdown"
        role="menu"
        phx-click-away="toggle_filter_panel"
        class="absolute left-0 top-full mt-1 rounded-lg border py-2 px-3 shadow-lg"
        style="background: var(--grok-bg-elevated); border-color: var(--grok-border); z-index: 40; min-width: 280px;"
      >
        <%= for key <- @visible_keys do %>
          <div
            id={"filter-panel-row-#{key}"}
            class="mb-2 last:mb-0"
          >
            <span class="block text-xs mb-1" style="color: var(--grok-text-secondary);">
              {filter_label(key)}:
            </span>
            <div class="flex flex-wrap gap-1">
              <%= for {value, label} <- choices_for(key) do %>
                <button
                  type="button"
                  id={"filter-panel-choice-#{key}-#{value}"}
                  role="menuitemradio"
                  aria-pressed={to_string(Map.get(@filters, key) == value)}
                  phx-click="set_filter"
                  phx-value-key={to_string(key)}
                  phx-value-value={to_string(value)}
                  class={[
                    "px-2 py-0.5 rounded-md text-xs transition-colors",
                    Map.get(@filters, key) == value &&
                      "text-white",
                    Map.get(@filters, key) != value &&
                      "hover:bg-[var(--grok-bg-tertiary)]"
                  ]}
                  style={
                    if Map.get(@filters, key) == value,
                      do: "background: var(--grok-accent);",
                      else: "background: var(--grok-bg-tertiary); color: var(--grok-text-secondary);"
                  }
                >
                  {label}
                </button>
              <% end %>
            </div>
          </div>
        <% end %>

        <div class="mt-2 pt-2 border-t" style="border-color: var(--grok-border);">
          <button
            type="button"
            id="filter-panel-reset"
            phx-click="reset_filters"
            class="w-full rounded-md px-2 py-1 text-xs transition-colors hover:bg-[var(--grok-bg-tertiary)]"
            style="color: var(--grok-text-secondary);"
          >
            Reset all
          </button>
        </div>
      </div>
    </div>
    """
  end

  defp choices_for(key), do: Map.get(@filter_choices, key, [])

  defp filter_label(:source_domain), do: "Domain"
  defp filter_label(:priority), do: "Priority"
  defp filter_label(:status), do: "Status"
  defp filter_label(other) when is_atom(other), do: Atom.to_string(other)

  defp choice_label(key, value) do
    choices_for(key)
    |> Enum.find_value(&if elem(&1, 0) == value, do: elem(&1, 1))
    |> case do
      nil -> to_string(value)
      label -> label
    end
  end

  defp active?(value) when value in [nil, :all], do: false
  defp active?(_value), do: true

  defp active_count(filters, visible_keys) do
    Enum.count(visible_keys, fn key ->
      active?(Map.get(filters, key))
    end)
  end
end
