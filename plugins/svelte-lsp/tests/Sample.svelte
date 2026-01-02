<script>
  /**
   * Sample Svelte component for LSP plugin validation.
   *
   * This file contains various Svelte constructs to test:
   * - LSP operations (hover, go to definition, references)
   * - Hook validation (formatting, linting, type checking)
   */

  // Props
  export let name = 'World';
  export let theme = 'light';

  // State
  let count = 0;
  let isExpanded = false;
  let todos = [
    { id: 1, text: 'Learn Svelte', completed: true },
    { id: 2, text: 'Build something awesome', completed: false },
  ];

  // Computed values (reactive declarations)
  $: greeting = `Hello, ${name}!`;
  $: completedCount = todos.filter(todo => todo.completed).length;
  $: percentage = todos.length > 0 ? (completedCount / todos.length) * 100 : 0;

  // Functions
  function increment() {
    count += 1;
  }

  function decrement() {
    if (count > 0) {
      count -= 1;
    }
  }

  function toggleExpanded() {
    isExpanded = !isExpanded;
  }

  function toggleTodo(id) {
    todos = todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    );
  }

  function addTodo(text) {
    const newTodo = {
      id: Math.max(0, ...todos.map(t => t.id)) + 1,
      text,
      completed: false,
    };
    todos = [...todos, newTodo];
  }

  // TODO: Add keyboard navigation
  // FIXME: Handle edge case when todos list is very long
</script>

<div class="container" class:dark={theme === 'dark'}>
  <h1>{greeting}</h1>

  <section class="counter">
    <h2>Counter Example</h2>
    <div class="controls">
      <button on:click={decrement} disabled={count === 0}>-</button>
      <span class="count">{count}</span>
      <button on:click={increment}>+</button>
    </div>
  </section>

  <section class="todos">
    <h2>Todo List</h2>
    <div class="progress">
      <span>{completedCount} / {todos.length} completed</span>
      <span>({percentage.toFixed(0)}%)</span>
    </div>

    <ul>
      {#each todos as todo (todo.id)}
        <li class:completed={todo.completed}>
          <input
            type="checkbox"
            checked={todo.completed}
            on:change={() => toggleTodo(todo.id)}
          />
          <span>{todo.text}</span>
        </li>
      {:else}
        <li class="empty">No todos yet!</li>
      {/each}
    </ul>
  </section>

  <section class="expandable">
    <button on:click={toggleExpanded}>
      {isExpanded ? 'Hide' : 'Show'} Details
    </button>

    {#if isExpanded}
      <div class="details">
        <p>This is an expandable section demonstrating conditional rendering.</p>
        <p>Current theme: <strong>{theme}</strong></p>
        <p>Counter value: <strong>{count}</strong></p>
      </div>
    {/if}
  </section>
</div>

<style>
  .container {
    max-width: 600px;
    margin: 2rem auto;
    padding: 2rem;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  }

  .container.dark {
    background-color: #1e1e1e;
    color: #e0e0e0;
  }

  h1 {
    color: #ff3e00;
    margin-top: 0;
  }

  h2 {
    font-size: 1.25rem;
    margin-bottom: 1rem;
    color: #333;
  }

  .dark h2 {
    color: #e0e0e0;
  }

  section {
    margin-bottom: 2rem;
    padding: 1rem;
    background-color: #f9f9f9;
    border-radius: 4px;
  }

  .dark section {
    background-color: #2a2a2a;
  }

  .counter .controls {
    display: flex;
    align-items: center;
    gap: 1rem;
  }

  .count {
    font-size: 2rem;
    font-weight: bold;
    min-width: 3rem;
    text-align: center;
  }

  button {
    padding: 0.5rem 1rem;
    font-size: 1rem;
    background-color: #ff3e00;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  button:hover:not(:disabled) {
    background-color: #cc3200;
  }

  button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
  }

  .progress {
    display: flex;
    justify-content: space-between;
    margin-bottom: 1rem;
    font-size: 0.9rem;
    color: #666;
  }

  .dark .progress {
    color: #aaa;
  }

  ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  li {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem;
    margin-bottom: 0.5rem;
    background-color: white;
    border-radius: 4px;
  }

  .dark li {
    background-color: #333;
  }

  li.completed {
    opacity: 0.6;
  }

  li.completed span {
    text-decoration: line-through;
  }

  li.empty {
    font-style: italic;
    color: #999;
    justify-content: center;
  }

  input[type='checkbox'] {
    width: 1.25rem;
    height: 1.25rem;
    cursor: pointer;
  }

  .details {
    margin-top: 1rem;
    padding: 1rem;
    background-color: #e8f4fd;
    border-left: 4px solid #0074d9;
    border-radius: 4px;
  }

  .dark .details {
    background-color: #1a3a52;
    border-left-color: #4a90e2;
  }

  .details p {
    margin: 0.5rem 0;
  }
</style>
