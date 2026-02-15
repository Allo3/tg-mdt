<script>
  export let title = 'TG MDT'
  export let onClose = () => {}
  let q = ''
  function submit(e) {
    e.preventDefault()
  }
</script>

<div class="topbar">
  <div class="left">
    <div class="title">{title}</div>
  </div>
  <form class="search" on:submit|preventDefault={submit}>
    <input placeholder="Rechercher..." bind:value={q} />
  </form>
  <div class="right">
    <button class="close" on:click={onClose}>Fermer</button>
  </div>
</div>

<style>
  .topbar {
    display: grid;
    grid-template-columns: 1fr auto auto;
    align-items: center;
    gap: 12px;
    padding: 10px 12px;
    border-bottom: 1px solid var(--stroke);
    background: rgba(0,0,0,.10);
  }
  .title {
    font-weight: 700;
    letter-spacing: .4px;
  }
  .search input {
    width: 320px;
    max-width: 40vw;
    background: rgba(255,255,255,.05);
    color: var(--text);
    border: 1px solid rgba(255,255,255,.12);
    border-radius: 14px;
    padding: 8px 10px;
    outline: none;
  }
  .search input:focus {
    border-color: rgba(46,243,255,.30);
    box-shadow: 0 0 0 3px rgba(46,243,255,.10);
  }
  .close {
    background: rgba(255,255,255,.06);
    color: var(--text);
    border: 1px solid rgba(255,255,255,.12);
    padding: 8px 12px;
    border-radius: 14px;
    cursor: pointer;
    transition: background 120ms var(--ease-out), border-color 120ms var(--ease-out), transform 120ms var(--ease-out);
  }
  .close:hover {
    background: rgba(255,255,255,.10);
    border-color: rgba(255,46,196,.25);
    transform: translateY(-1px);
  }
</style>
