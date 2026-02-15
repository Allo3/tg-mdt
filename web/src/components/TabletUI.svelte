<script lang="ts">
  import { visibility } from '../store/stores'
  import { fetchNui } from '../utils/fetchNui'
  import Topbar from './Topbar.svelte'
  import Sidebar from './Sidebar.svelte'
  type Case = { id: number; title: string; status: string }
  let section = 'dashboard'
  let cases: Case[] = []
  function close() {
    visibility.set(false)
    fetchNui('hideUI')
  }
  function navigate(k: string) { section = k }
</script>

<div class="tablet">
  <div class="bezel">
    <div class="cam"></div>
    <div class="screen">
      <Topbar title="TG MDT" onClose={close} />
      <div class="layout">
        <Sidebar active={section} onNavigate={navigate} />
        <div class="page">
          {#if section === 'dashboard'}
            <div class="cards">
              <div class="card"><div class="k">Incidents</div><div class="v">{cases.length}</div></div>
              <div class="card"><div class="k">Ouverts</div><div class="v">{cases.filter(c => c.status === 'Ouvert').length}</div></div>
              <div class="card"><div class="k">Enquête</div><div class="v">{cases.filter(c => c.status === 'Enquête').length}</div></div>
            </div>
            <div class="section-title">Récents</div>
            {#if cases.length === 0}
              <div class="empty">Aucun dossier</div>
            {:else}
              <ul class="list">
                {#each cases as c}
                  <li class="item">
                    <div class="id">#{c.id}</div>
                    <div class="title">{c.title}</div>
                    <div class="status">{c.status}</div>
                  </li>
                {/each}
              </ul>
            {/if}
          {:else if section === 'incidents'}
            <div class="section-title">Incidents</div>
            <div class="empty">Liste à venir</div>
          {:else if section === 'profiles'}
            <div class="section-title">Profils</div>
            <div class="empty">Recherche à venir</div>
          {:else if section === 'vehicles'}
            <div class="section-title">Véhicules</div>
            <div class="empty">Recherche à venir</div>
          {:else if section === 'reports'}
            <div class="section-title">Rapports</div>
            <div class="empty">Rédaction à venir</div>
          {:else if section === 'settings'}
            <div class="section-title">Paramètres</div>
            <div class="empty">Options à venir</div>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .tablet {
    position: absolute;
    inset: 5% 8%;
    display: grid;
    place-items: center;
    pointer-events: auto;
    font-family: Inter, system-ui, Arial, sans-serif;
    color: #e9e9e9;
  }
  .bezel {
    position: relative;
    width: min(1100px, 84vw);
    height: min(700px, 78vh);
    background: #0f0f12;
    border: 10px solid #0a0a0c;
    border-radius: 26px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.6), inset 0 0 40px rgba(0,0,0,0.5);
    padding: 14px;
  }
  .cam {
    position: absolute;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: radial-gradient(circle at 30% 30%, #2b6cff, #0b0d12);
    top: 8px;
    left: 50%;
    transform: translateX(-50%);
  }
  .screen {
    position: absolute;
    inset: 14px;
    background: #121214f2;
    border: 1px solid #2a2a2a;
    border-radius: 16px;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }
  .layout {
    display: grid;
    grid-template-columns: 220px 1fr;
    min-height: 0;
    flex: 1;
  }
  .page {
    padding: 14px;
    overflow: auto;
  }
  .section-title {
    font-weight: 600;
    margin: 8px 0 10px;
  }
  .cards {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 10px;
    margin-bottom: 12px;
  }
  .card {
    background: #1a1a1f;
    border: 1px solid #2b2b2f;
    border-radius: 10px;
    padding: 12px;
  }
  .card .k { opacity: .8; font-size: 12px }
  .card .v { font-size: 20px; font-weight: 700 }
  .list {
    list-style: none;
    padding: 0;
    margin: 0;
    display: grid;
    grid-template-columns: 1fr;
    gap: 8px;
  }
  .item {
    display: grid;
    grid-template-columns: 80px 1fr 120px;
    gap: 8px;
    align-items: center;
    padding: 10px 12px;
    background: #1e1e22;
    border: 1px solid #2b2b2f;
    border-radius: 6px;
  }
  .id { color: #8ea0ff }
  .status { color: #9be69b }
  .empty { opacity: 0.8 }
</style>
