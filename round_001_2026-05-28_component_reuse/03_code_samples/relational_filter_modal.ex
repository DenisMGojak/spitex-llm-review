defmodule MegalithWeb.Components.RelationalFilterModal do
  @moduledoc """
  OrgUnit-style multi-select modal for relational filter picks (People, Projects).

  Replaces iter 267's `RelationalFilterChip` inline popover with a modal that
  provides pending-selection + Apply/Cancel pattern, more room for result
  rendering, and matches the existing OrgUnit add-person modal pattern
  (`OrganizationGrokLive`).

  ## Public API

      <.live_component
        module={MegalithWeb.Components.RelationalFilterModal}
        id="filter-people"
        label="People"
        modal_title="Filter by people"
        placeholder="Search by name or email..."
        selected={@filters.assignee_ids || []}
        options_provider={Megalith.OptionsProviders.People}
        options_provider_opts={[tenant_id: @current_tenant_id]}
        current_user={@current_user}
      />

  Parent receives: `{:filter_changed, chip_id, list_of_ids}`
  """

  use MegalithWeb, :live_component

  alias Megalith.OptionsProvider

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(:open, false)
     |> assign(:search_query, "")
     |> assign(:results, [])
     |> assign(:loading, false)
     |> assign(:error, nil)
     |> assign(:focused_index, -1)
     |> assign(:pending_selection, MapSet.new())
     |> assign(:label_cache, %{})
     |> assign(:search_timer, nil)}
  end

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_new(:placeholder, fn -> "Search..." end)
      |> assign_new(:selected, fn -> [] end)
      |> assign_new(:options_provider_opts, fn -> [] end)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id={"filter-modal-#{@id}-wrapper"} class="inline-flex items-center">
      <%!-- Trigger button --%>
      <button
        type="button"
        id={"filter-modal-#{@id}-trigger"}
        class={[
          "px-2 py-0.5 rounded-md text-xs transition-colors",
          if(length(MapSet.to_list(@pending_selection)) > 0 or length(@selected) > 0,
            do: "text-white",
            else: "hover:bg-[var(--grok-bg-tertiary)]"
          )
        ]}
        style={
          if length(@selected) > 0 or length(MapSet.to_list(@pending_selection)) > 0,
            do: "background: var(--grok-accent);",
            else: "background: var(--grok-bg-tertiary); color: var(--grok-text-secondary);"
        }
        phx-click="toggle_modal"
        phx-target={@myself}
        aria-haspopup="dialog"
        aria-expanded={to_string(@open)}
      >
        {@label}
        <%= if length(@selected) > 0 do %>
          <span class="ml-1 opacity-75">({length(@selected)})</span>
        <% end %>
      </button>

      <%!-- Modal --%>
      <%= if @open do %>
        <div
          id={"filter-modal-#{@id}-backdrop"}
          style="
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 50;
            padding: var(--grok-space-lg);
          "
        >
          <div
            id={"filter-modal-#{@id}-dialog"}
            phx-click-away="cancel"
            phx-target={@myself}
            phx-window-keydown="handle_keydown"
            phx-target-window={@myself}
            role="dialog"
            aria-modal="true"
            aria-labelledby={"filter-modal-#{@id}-title"}
            style="
              background: var(--grok-bg-primary);
              border-radius: var(--grok-radius-lg);
              border: 1px solid var(--grok-border);
              max-width: 500px;
              width: 100%;
              max-height: 80vh;
              overflow: auto;
              box-shadow: var(--grok-shadow-2xl);
            "
          >
            <%!-- Header --%>
            <div style="
              padding: var(--grok-space-lg);
              border-bottom: 1px solid var(--grok-border);
              display: flex;
              align-items: center;
              justify-content: space-between;
            ">
              <h3
                id={"filter-modal-#{@id}-title"}
                style="font-size: var(--grok-text-xl); font-weight: var(--grok-font-bold); color: var(--grok-text-primary);"
              >
                {@modal_title}
              </h3>
              <button
                type="button"
                phx-click="cancel"
                phx-target={@myself}
                style="
                  padding: var(--grok-space-sm);
                  background: transparent;
                  border: none;
                  color: var(--grok-text-secondary);
                  cursor: pointer;
                "
                aria-label="Close"
              >
                <.icon name="hero-x-mark" class="w-5 h-5" />
              </button>
            </div>

            <%!-- Content --%>
            <div style="padding: var(--grok-space-lg);">
              <%!-- Search input --%>
              <div style="margin-bottom: var(--grok-space-md);">
                <input
                  type="text"
                  id={"filter-modal-#{@id}-search-input"}
                  name="query"
                  value={@search_query}
                  placeholder={@placeholder}
                  autofocus
                  phx-change="search"
                  phx-target={@myself}
                  phx-debounce="250"
                  aria-label={"Search " <> @label}
                  style="
                    width: 100%;
                    padding: var(--grok-space-sm) var(--grok-space-md);
                    border: 1px solid var(--grok-border);
                    border-radius: var(--grok-radius-md);
                    background: var(--grok-bg-primary);
                    color: var(--grok-text-primary);
                    font-size: var(--grok-text-sm);
                    outline: none;
                  "
                />
              </div>

              <%!-- Pending selection chips --%>
              <%= if MapSet.size(@pending_selection) > 0 do %>
                <div class="flex flex-wrap gap-1 mb-3">
                  <%= for id <- MapSet.to_list(@pending_selection) do %>
                    <span
                      id={"filter-modal-#{@id}-chip-#{id}"}
                      style="
                        display: inline-flex;
                        align-items: center;
                        gap: 4px;
                        padding: 2px 8px;
                        background: var(--grok-bg-tertiary);
                        border-radius: var(--grok-radius-full);
                        font-size: var(--grok-text-xs);
                        color: var(--grok-text-primary);
                      "
                    >
                      {Map.get(@label_cache, id, id)}
                      <button
                        type="button"
                        phx-click="toggle_selection"
                        phx-value-id={id}
                        phx-target={@myself}
                        style="
                          background: transparent;
                          border: none;
                          cursor: pointer;
                          color: var(--grok-text-secondary);
                          padding: 0;
                          line-height: 1;
                        "
                        aria-label={"Remove #{Map.get(@label_cache, id, id)}"}
                      >
                        <.icon name="hero-x-mark" class="w-3 h-3" />
                      </button>
                    </span>
                  <% end %>
                </div>
              <% end %>

              <%!-- Results listbox --%>
              <div
                id={"filter-modal-#{@id}-results"}
                role="listbox"
                aria-multiselectable="true"
                aria-activedescendant={
                  if @focused_index >= 0 and @focused_index < length(@results),
                    do: "filter-modal-#{@id}-result-#{elem(Enum.at(@results, @focused_index), 0)}"
                }
                style="
                  max-height: 300px;
                  overflow-y: auto;
                  border: 1px solid var(--grok-border);
                  border-radius: var(--grok-radius-md);
                "
              >
                <%= if @loading do %>
                  <div class="p-4 text-center text-sm" style="color: var(--grok-text-secondary);">
                    Loading...
                  </div>
                <% else %>
                  <%= for {id, label, sub_label} <- @results do %>
                    <div
                      id={"filter-modal-#{@id}-result-#{id}"}
                      role="option"
                      aria-selected={to_string(MapSet.member?(@pending_selection, id))}
                      tabindex="-1"
                      phx-click="toggle_selection"
                      phx-value-id={id}
                      phx-target={@myself}
                      style={[
                        "padding: var(--grok-space-sm) var(--grok-space-md);",
                        "cursor: pointer;",
                        "display: flex;",
                        "align-items: center;",
                        "justify-content: space-between;",
                        "border-bottom: 1px solid var(--grok-border);",
                        if(MapSet.member?(@pending_selection, id),
                          do: "background: color-mix(in srgb, var(--grok-accent) 15%, transparent);",
                          else: ""
                        ),
                        if(
                          @focused_index >= 0 && @focused_index < length(@results) &&
                            elem(Enum.at(@results, @focused_index), 0) == id,
                          do: "background: var(--grok-bg-tertiary);",
                          else: ""
                        )
                      ]}
                    >
                      <div>
                        <div style="color: var(--grok-text-primary); font-size: var(--grok-text-sm);">
                          {label}
                        </div>
                        <%= if sub_label do %>
                          <div style="color: var(--grok-text-secondary); font-size: var(--grok-text-xs); margin-top: 2px;">
                            {sub_label}
                          </div>
                        <% end %>
                      </div>
                      <%= if MapSet.member?(@pending_selection, id) do %>
                        <.icon name="hero-check" class="w-4 h-4" style="color: var(--grok-accent);" />
                      <% end %>
                    </div>
                  <% end %>
                  <%= if @results == [] and @search_query != "" and not @loading do %>
                    <div class="p-4 text-center text-sm" style="color: var(--grok-text-secondary);">
                      No results found
                    </div>
                  <% end %>
                <% end %>
              </div>
            </div>

            <%!-- Footer --%>
            <div style="
              padding: var(--grok-space-md) var(--grok-space-lg);
              border-top: 1px solid var(--grok-border);
              display: flex;
              align-items: center;
              justify-content: space-between;
            ">
              <button
                type="button"
                id={"filter-modal-#{@id}-clear"}
                phx-click="clear"
                phx-target={@myself}
                class="text-xs px-2 py-1 rounded hover:bg-[var(--grok-bg-tertiary)]"
                style="color: var(--grok-text-secondary); background: transparent; border: none; cursor: pointer;"
              >
                Clear
              </button>
              <div class="flex gap-2">
                <button
                  type="button"
                  id={"filter-modal-#{@id}-cancel"}
                  phx-click="cancel"
                  phx-target={@myself}
                  class="text-xs px-3 py-1 rounded"
                  style="
                    background: var(--grok-bg-tertiary);
                    color: var(--grok-text-secondary);
                    border: 1px solid var(--grok-border);
                    cursor: pointer;
                  "
                >
                  Cancel
                </button>
                <button
                  type="button"
                  id={"filter-modal-#{@id}-apply"}
                  phx-click="apply"
                  phx-target={@myself}
                  class="text-xs px-3 py-1 rounded text-white"
                  style="
                    background: var(--grok-accent);
                    border: none;
                    cursor: pointer;
                  "
                >
                  Apply
                </button>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("toggle_modal", _params, socket) do
    if socket.assigns.open do
      {:noreply, assign(socket, :open, false)}
    else
      {:noreply,
       socket
       |> assign(:open, true)
       |> assign(:pending_selection, MapSet.new(socket.assigns.selected))
       |> assign(:search_query, "")
       |> assign(:results, [])
       |> assign(:focused_index, -1)
       |> assign(:error, nil)}
    end
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    if String.length(query) >= 2 do
      send(self(), {:do_search, query})
    end

    {:noreply, assign(socket, :search_query, query)}
  end

  def handle_info({:do_search, query}, socket) do
    provider = socket.assigns.options_provider
    actor = socket.assigns.current_user
    opts = socket.assigns.options_provider_opts

    case provider.search(actor, query, opts) do
      {:ok, results} ->
        label_cache =
          Enum.reduce(results, socket.assigns.label_cache, fn {id, label, _sub}, acc ->
            Map.put(acc, id, label)
          end)

        {:noreply,
         socket
         |> assign(:results, results)
         |> assign(:loading, false)
         |> assign(:label_cache, label_cache)
         |> assign(:focused_index, -1)}

      {:error, _reason} ->
        {:noreply,
         socket
         |> assign(:results, [])
         |> assign(:loading, false)
         |> assign(:error, "Search failed. Please try again.")}
    end
  end

  @impl true
  def handle_event("toggle_selection", %{"id" => id}, socket) do
    pending = socket.assigns.pending_selection

    updated =
      if MapSet.member?(pending, id) do
        MapSet.delete(pending, id)
      else
        MapSet.put(pending, id)
      end

    {:noreply, assign(socket, :pending_selection, updated)}
  end

  @impl true
  def handle_event("apply", _params, socket) do
    ids = MapSet.to_list(socket.assigns.pending_selection)

    send(self(), {:filter_changed, socket.assigns.id, ids})

    {:noreply, assign(socket, :open, false)}
  end

  @impl true
  def handle_event("clear", _params, socket) do
    {:noreply, assign(socket, :pending_selection, MapSet.new())}
  end

  @impl true
  def handle_event("cancel", _params, socket) do
    {:noreply, assign(socket, :open, false)}
  end

  @impl true
  def handle_event("handle_keydown", %{"key" => key}, socket) do
    if socket.assigns.open do
      case key do
        "Escape" ->
          {:noreply, assign(socket, :open, false)}

        "ArrowDown" ->
          max_idx = max(0, length(socket.assigns.results) - 1)
          new_idx = min(socket.assigns.focused_index + 1, max_idx)
          {:noreply, assign(socket, :focused_index, new_idx)}

        "ArrowUp" ->
          new_idx = max(socket.assigns.focused_index - 1, 0)
          {:noreply, assign(socket, :focused_index, new_idx)}

        "Enter" ->
          if socket.assigns.focused_index >= 0 and
               socket.assigns.focused_index < length(socket.assigns.results) do
            {focused_id, _, _} = Enum.at(socket.assigns.results, socket.assigns.focused_index)
            pending = socket.assigns.pending_selection

            updated =
              if MapSet.member?(pending, focused_id) do
                MapSet.delete(pending, focused_id)
              else
                MapSet.put(pending, focused_id)
              end

            {:noreply, assign(socket, :pending_selection, updated)}
          else
            {:noreply, socket}
          end

        _ ->
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end
end
