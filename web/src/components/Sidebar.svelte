<script>
  export let active = 'dashboard'
  export let onNavigate = (k) => {}
  const items = [
    { key: 'dashboard', label: 'Tableau de bord', icon: '🏠' },
    { key: 'incidents', label: 'Incidents', icon: '📁' },
    { key: 'profiles', label: 'Profils', icon: '🧑' },
    { key: 'vehicles', label: 'Véhicules', icon: '🚗' },
    { key: 'reports', label: 'Rapports', icon: '📝' },
    { key: 'settings', label: 'Paramètres', icon: '⚙️' }
  ]
</script>

<nav class="sidebar">
  {#each items as it}
    <button
      class="item {active === it.key ? 'active' : ''}"
      on:click={() => onNavigate(it.key)}
      aria-current={active === it.key ? 'page' : undefined}
    >
      <span class="ic">{it.icon}</span>
      <span class="lb">{it.label}</span>
    </button>
  {/each}
  <div class="foot">v0.1</div>
  </nav>

<style>
  .sidebar {
    width: 220px;
    background: rgba(255,255,255,.03);
    border-right: 1px solid var(--stroke);
    display: flex;
    flex-direction: column;
    padding: 8px;
    gap: 6px;
  }
  .item {
    display: grid;
    grid-template-columns: 28px 1fr;
    align-items: center;
    gap: 8px;
    padding: 10px 10px;
    border: 1px solid transparent;
    border-radius: 12px;
    background: rgba(255,255,255,.02);
    color: var(--text);
    cursor: pointer;
    transition: transform 120ms var(--ease-out), background 120ms var(--ease-out), border-color 120ms var(--ease-out);
  }
  .item:hover {
    background: rgba(255,255,255,.05);
    border-color: rgba(255,255,255,.10);
    transform: translateY(-1px);
  }
  .item.active {
    background: rgba(46,243,255,.08);
    border-color: rgba(46,243,255,.22);
  }
  .ic { text-align: center }
  .lb { text-align: left }
  .foot {
    margin-top: auto;
    color: var(--muted);
    font-size: 12px;
    text-align: center;
    padding: 6px 0;
  }
</style>
