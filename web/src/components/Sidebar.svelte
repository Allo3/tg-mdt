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
    background: #141417;
    border-right: 1px solid #2a2a2a;
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
    border: 1px solid #1f1f24;
    border-radius: 8px;
    background: #1a1a1f;
    color: #e9e9e9;
    cursor: pointer;
  }
  .item:hover { border-color: #2f2f35 }
  .item.active {
    background: #20202a;
    border-color: #3d47ff66;
  }
  .ic { text-align: center }
  .lb { text-align: left }
  .foot {
    margin-top: auto;
    opacity: .6;
    font-size: 12px;
    text-align: center;
    padding: 6px 0;
  }
</style>
