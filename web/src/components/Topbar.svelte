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
    border-bottom: 1px solid #2a2a2a;
    background: #161619;
  }
  .title {
    font-weight: 700;
    letter-spacing: .4px;
  }
  .search input {
    width: 320px;
    max-width: 40vw;
    background: #1f1f24;
    color: #e9e9e9;
    border: 1px solid #2b2b2f;
    border-radius: 6px;
    padding: 8px 10px;
    outline: none;
  }
  .search input:focus { border-color: #3d47ff66 }
  .close {
    background: #444;
    color: white;
    border: 0;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
  }
  .close:hover { background: #555 }
</style>
