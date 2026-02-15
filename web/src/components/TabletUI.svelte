<script lang="ts">
  import { visibility } from '../store/stores'
  import Topbar from './Topbar.svelte'
  import Sidebar from './Sidebar.svelte'
  import ProfilesTab from './tabs/ProfilesTab.svelte'
  import { fetchNui } from '../utils/fetchNui'
  import type { Profile } from "../store/stores";
  import { profilesSearch } from '../store/search'
  import ProfileDrawer from './drawers/ProfilDrawer.svelte'
  import VehiclesTab from './tabs/VehiclesTab.svelte'
  import VehicleDrawer from './drawers/VehicleDrawer.svelte'
  import type { Vehicle } from '../store/stores'
  type Case = { id: number; title: string; status: string }
  import { get } from 'svelte/store'
  let section: string = 'dashboard'
  let cases: Case[] = []

  let selectedProfile: Profile | null = null
  let drawerOpen = false
  let vehiclesOwnerPrefill: string | null = null
  let selectedVehicle: Vehicle | null = null
  let vehicleDrawerOpen = false
  let vehiclesPrefill: string | null = null

  let pendingProfileCid: string | null = null

  async function getProfileForOwner(cid: string) {
    // switch onglet
    section = 'profiles'

    // ferme drawer véhicule
    closeVehicleDrawer?.() // si tu as la fonction
    // ou:
    // vehicleDrawerOpen = false; selectedVehicle = null;

    // prépare ouverture automatique
    pendingProfileCid = cid

    // lance la recherche profils + persiste
    profilesSearch.query.set(cid)
    await profilesSearch.search(cid)
  }



  function close() {
    visibility.set(false)
    fetchNui('hideUI')
  }

  function navigate(k: string) {
    section = k

    // Optionnel: fermer le drawer si on quitte Profils
    if (k !== 'profiles') closeDrawer()
  }

  function openProfileDrawer(p: Profile) {
    selectedProfile = p
    drawerOpen = true
  }

  function closeDrawer() {
    drawerOpen = false
    selectedProfile = null
  }

  function getVehiclesForOwner(cid: string){
    vehiclesOwnerPrefill = cid
    section = 'vehicles'
    closeDrawer()
  }

  function openVehicleDrawer(v: Vehicle) {
    selectedVehicle = v
    vehicleDrawerOpen = true
  }

  function closeVehicleDrawer() {
    vehicleDrawerOpen = false
    selectedVehicle = null
  }


  async function goProfileForOwner(cid: string) {
    section = 'profiles'
    vehiclesPrefill = null
    vehicleDrawerOpen = false
    selectedVehicle = null
    // on préremplit la recherche profils
    setTimeout(() => {
      // hack simple : dispatch event plus tard si tu veux auto-open
    }, 50)
    await profilesSearch.search(cid)
    tryOpenPendingProfile()
  }


  function tryOpenPendingProfile() {
    if (!pendingProfileCid) return

    const list = get(profilesSearch.results)
    const found = list.find(p => p.citizenid === pendingProfileCid)

    if (found) {
      openProfileDrawer(found)
      pendingProfileCid = null
    }
  }

  $: if (pendingProfileCid && section === 'profiles') {
    const list = profilesSearch.results; // ⚠️ on ne peut pas utiliser $ ici dans <script> sans store direct
  }
</script>

<div class="tablet">
  <div class="bezel">
    <div class="cam"></div>

    <div class="screen">
      <Topbar title="TG MDT" onClose={close} />

      <div class="layout">
        <Sidebar active={section} onNavigate={navigate} />

        <div class="page {drawerOpen && section === 'profiles' ? 'with-drawer' : ''}">
          <div class="page-main">
            {#if section === 'dashboard'}
              <div class="cards">
                <div class="card">
                  <div class="k">Incidents</div>
                  <div class="v">{cases.length}</div>
                </div>
                <div class="card">
                  <div class="k">Ouverts</div>
                  <div class="v">{cases.filter(c => c.status === 'Ouvert').length}</div>
                </div>
                <div class="card">
                  <div class="k">Enquête</div>
                  <div class="v">{cases.filter(c => c.status === 'Enquête').length}</div>
                </div>
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
              <ProfilesTab on:select={(e) => openProfileDrawer(e.detail)} />

            {:else if section === 'vehicles'}
              <div class="section-title">Véhicules</div>
              <VehiclesTab
                      initialQuery={vehiclesPrefill}
                      on:select={(e) => openVehicleDrawer(e.detail)}
              />

            {:else if section === 'reports'}
              <div class="section-title">Rapports</div>
              <div class="empty">Rédaction à venir</div>

            {:else if section === 'settings'}
              <div class="section-title">Paramètres</div>
              <div class="empty">Options à venir</div>
            {/if}
          </div>

          {#if drawerOpen && section === 'profiles'}
            <div class="page-drawer">
              <ProfileDrawer
                      profile={selectedProfile}
                      onClose={closeDrawer}
                      onVehicles={getVehiclesForOwner}
              />
            </div>
          {/if}
          {#if vehicleDrawerOpen && section === 'vehicles'}
            <div class="page-drawer">
              <VehicleDrawer
                      vehicle={selectedVehicle}
                      onClose={closeVehicleDrawer}
                      onOwner={goProfileForOwner}
              />
            </div>
          {/if}
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .tablet {
    width: min(1200px, calc(100vw - 72px));
    height: min(760px, calc(100vh - 72px));
    display: grid;
    place-items: stretch;
  }

  .bezel {
    position: relative;
    width: 100%;
    height: 100%;
    background: rgba(10, 10, 12, 0.92);
    border: 10px solid rgba(0, 0, 0, 0.55);
    border-radius: 28px;
    box-shadow: var(--shadow), inset 0 0 40px rgba(0, 0, 0, 0.55);
    padding: 14px;
    overflow: hidden;
  }

  .bezel::before {
    content: "";
    position: absolute;
    inset: -2px;
    background:
            radial-gradient(800px 420px at 14% 10%, rgba(46,243,255,.16), transparent 60%),
            radial-gradient(800px 420px at 86% 8%, rgba(255,46,196,.12), transparent 60%),
            radial-gradient(900px 500px at 50% 112%, rgba(46,243,255,.08), transparent 60%);
    pointer-events: none;
    filter: blur(6px);
    opacity: .75;
  }

  .cam {
    position: absolute;
    width: 10px;
    height: 10px;
    border-radius: 50%;
    background: radial-gradient(circle at 30% 30%, var(--primary), #0b0d12);
    top: 8px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 2;
  }

  .screen {
    position: absolute;
    inset: 14px;
    background: var(--bg);
    border: 1px solid var(--stroke);
    border-radius: 18px;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    backdrop-filter: blur(var(--blur));
    z-index: 1;
  }

  .layout {
    display: grid;
    grid-template-columns: 220px 1fr;
    min-height: 0;
    flex: 1;
  }

  /* IMPORTANT: on gère le scroll dans page-main, pas sur .page */
  .page {
    padding: 14px;
    overflow: hidden;
    min-height: 0;
  }

  .page.with-drawer {
    display: grid;
    grid-template-columns: 1fr 360px;
    gap: 12px;
  }

  .page-main {
    overflow: auto;
    min-height: 0;
  }

  .page-drawer {
    min-height: 0;
    overflow: hidden;
    border-radius: 14px;
    border: 1px solid rgba(255,255,255,.08);
    background: rgba(255,255,255,.03);
  }

  .section-title {
    font-weight: 600;
    margin: 8px 0 10px;
  }

  /* Cards adaptatives: se “raccourcissent” quand le drawer prend de la place */
  .cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 10px;
    margin-bottom: 12px;
  }

  .card {
    background: var(--panel);
    border: 1px solid var(--stroke);
    border-radius: var(--radius-md);
    padding: 12px;
    box-shadow: 0 10px 30px rgba(0,0,0,.25);
  }

  .card .k { color: var(--muted); font-size: 12px }
  .card .v { font-size: 20px; font-weight: 800; letter-spacing: .2px }

  .list {
    list-style: none;
    padding: 0;
    margin: 0;
    display: grid;
    gap: 8px;
  }

  .item {
    display: grid;
    grid-template-columns: 80px 1fr 120px;
    gap: 8px;
    align-items: center;
    padding: 10px 12px;
    background: var(--panel);
    border: 1px solid var(--stroke);
    border-radius: 10px;
  }

  .id { color: rgba(46,243,255,.9) }
  .status { color: rgba(43,255,136,.85) }
  .empty { color: var(--muted) }
</style>