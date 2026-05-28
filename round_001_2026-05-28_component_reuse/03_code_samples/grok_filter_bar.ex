defmodule MegalithWeb.Components.Grok.FilterBar do
  @moduledoc """
  Reusable Grok-styled filter bar component for list views.

  Provides consistent filtering UI across CRM, People, Projects, and other domains.
  Handles URL persistence via push_patch and supports mobile-friendly layouts.

  ## Features

  - Grok design system styling
  - URL persistence (push_patch)
  - Clear/Reset filters
  - Mobile-responsive
  - Accessible (labels, ARIA)

  ## Usage

      <.live_component
        module={FilterBar}
        id="contact-filters"
        search_value={@search_query}
        filters={[
          %{type: :select, name: "company", label: "Company", options: @companies, value: @filter_company},
          %{type: :select, name: "status", label: "Status", options: @statuses, value: @filter_status}
        ]}
        on_change="filter_change"
        on_clear="clear_filters"
      />

  ## Props

  - `id`: Component ID (required)
  - `search_value`: Current search query (string)
  - `search_placeholder`: Search input placeholder (default: "Search...")
  - `filters`: List of filter configs (see Filter Types below)
  - `on_change`: Event name for filter changes (default: "filter_change")
  - `on_clear`: Event name for clear action (default: "clear_filters")
  - `show_clear`: Show clear button (default: true)

  ## Filter Types

  ### Text Search
  ```elixir
  %{type: :search, name: "search", placeholder: "Search by name...", value: ""}
  ```

  ### Select (Single)
  ```elixir
  %{
    type: :select,
    name: "status",
    label: "Status",
    options: [{"All", ""}, {"Active", "active"}, {"Inactive", "inactive"}],
    value: "active"
  }
  ```

  ### Multiselect
  ```elixir
  %{
    type: :multiselect,
    name: "types",
    label: "Types",
    options: [{"Call", "call"}, {"Meeting", "meeting"}],
    value: ["call", "meeting"]
  }
  ```

  ### Date Range
  ```elixir
  %{
    type: :date_range,
    name_from: "date_from",
    name_to: "date_to",
    label: "Date Range",
    value_from: "2025-01-01",
    value_to: "2025-12-31"
  }
  ```
  """

  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      data-style-theme="grok"
      style="background: var(--grok-bg-secondary); padding: var(--grok-space-lg); border-radius: var(--grok-radius-lg); margin-bottom: var(--grok-space-xl); border: 1px solid var(--grok-border);"
    >
      <.form
        for={%{}}
        phx-change={@on_change}
        phx-target={@myself}
        style="display: flex; flex-wrap: wrap; gap: var(--grok-space-md); align-items: end;"
      >
        <%!-- Search Field --%>
        <%= if @search_enabled do %>
          <div style="flex: 1; min-width: 250px;">
            <label
              for={"#{@id}-search"}
              style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
            >
              Search
            </label>
            <input
              type="text"
              name="search"
              id={"#{@id}-search"}
              value={@search_value}
              placeholder={@search_placeholder}
              style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
              phx-debounce="300"
            />
          </div>
        <% end %>
        <%!-- Dynamic Filters --%>
        <%= for filter <- @filters do %>
          {render_filter(assigns, filter)}
        <% end %>
        <%!-- Clear Button --%>
        <%= if @show_clear do %>
          <button
            type="button"
            phx-click={@on_clear}
            phx-target={@myself}
            style="padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-tertiary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-secondary); font-size: var(--grok-text-sm); font-weight: var(--grok-font-semibold); cursor: pointer; transition: background 0.2s;"
            onmouseover="this.style.background='var(--grok-bg-secondary)'"
            onmouseout="this.style.background='var(--grok-bg-tertiary)'"
          >
            Clear
          </button>
        <% end %>
      </.form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_defaults()}
  end

  defp assign_defaults(socket) do
    socket
    |> assign_new(:search_enabled, fn -> socket.assigns[:search_value] != nil end)
    |> assign_new(:search_value, fn -> "" end)
    |> assign_new(:search_placeholder, fn -> "Search..." end)
    |> assign_new(:filters, fn -> [] end)
    |> assign_new(:on_change, fn -> "filter_change" end)
    |> assign_new(:on_clear, fn -> "clear_filters" end)
    |> assign_new(:show_clear, fn -> true end)
  end

  @impl true
  def handle_event("filter_change", params, socket) do
    # Forward to parent LiveView with original event name
    send(self(), {:filter_change, params})
    {:noreply, socket}
  end

  @impl true
  def handle_event("clear_filters", _params, socket) do
    # Forward to parent LiveView
    send(self(), :clear_filters)
    {:noreply, socket}
  end

  # ============================================================
  # Filter Rendering
  # ============================================================

  defp render_filter(assigns, %{type: :select} = filter) do
    assigns = assign(assigns, :filter, filter)

    ~H"""
    <div style="width: 200px;">
      <label
        for={"#{@id}-#{@filter.name}"}
        style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
      >
        {@filter.label}
      </label>
      <select
        name={@filter.name}
        id={"#{@id}-#{@filter.name}"}
        style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
      >
        <option
          :for={{label, value} <- @filter.options}
          value={value}
          selected={value == @filter.value}
        >
          {label}
        </option>
      </select>
    </div>
    """
  end

  defp render_filter(assigns, %{type: :date_range} = filter) do
    assigns = assign(assigns, :filter, filter)

    ~H"""
    <div style="display: flex; gap: var(--grok-space-sm);">
      <div style="width: 150px;">
        <label
          for={"#{@id}-#{@filter.name_from}"}
          style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
        >
          From
        </label>
        <input
          type="date"
          name={@filter.name_from}
          id={"#{@id}-#{@filter.name_from}"}
          value={@filter.value_from || ""}
          style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
        />
      </div>
      <div style="width: 150px;">
        <label
          for={"#{@id}-#{@filter.name_to}"}
          style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
        >
          To
        </label>
        <input
          type="date"
          name={@filter.name_to}
          id={"#{@id}-#{@filter.name_to}"}
          value={@filter.value_to || ""}
          style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
        />
      </div>
    </div>
    """
  end

  defp render_filter(assigns, %{type: :multiselect} = filter) do
    assigns = assign(assigns, :filter, filter)

    ~H"""
    <div style="width: 200px;">
      <label
        for={"#{@id}-#{@filter.name}"}
        style="display: block; font-size: var(--grok-text-sm); font-weight: var(--grok-font-medium); color: var(--grok-text-primary); margin-bottom: var(--grok-space-xs);"
      >
        {@filter.label}
      </label>
      <select
        name={"#{@filter.name}[]"}
        id={"#{@id}-#{@filter.name}"}
        multiple
        style="width: 100%; padding: var(--grok-space-sm) var(--grok-space-md); background: var(--grok-bg-primary); border: 1px solid var(--grok-border); border-radius: var(--grok-radius-md); color: var(--grok-text-primary); font-size: var(--grok-text-sm);"
      >
        <option
          :for={{label, value} <- @filter.options}
          value={value}
          selected={value in (@filter.value || [])}
        >
          {label}
        </option>
      </select>
    </div>
    """
  end

  defp render_filter(_assigns, _filter) do
    # Unknown filter type, skip rendering
    nil
  end
end
