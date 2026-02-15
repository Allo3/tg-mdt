<script lang="ts">
    import type { Profile, Vehicle } from '../../store/stores'
    export let profile: Profile | null = null;
    export let vehicle: Vehicle | null = null;
    export let onClose: () => void;
    export let onVehicles: (plate: string) => void

    async function copyCitizenId() {
        if (!profile?.citizenid) return;
        try {
            await navigator.clipboard.writeText(profile.citizenid);
        } catch {
            // fallback: rien (FiveM peut bloquer clipboard selon config)
        }
    }
</script>

{#if profile}
    <aside class="drawer">
        <div class="drawer-top">
            <div class="title">Profil</div>
            <button class="x" on:click={onClose} aria-label="Fermer">✕</button>
        </div>

        <div class="card">
            <div class="name">{profile.firstname} {profile.lastname}</div>
            <div class="meta">
                <span class="chip">{profile.citizenid}</span>
                {#if profile.job}<span class="chip muted">{profile.job}</span>{/if}
            </div>
        </div>

        <div class="grid">
            <div class="field">
                <div class="k">Naissance</div>
                <div class="v">{profile.dob ?? "—"}</div>
            </div>
            <div class="field">
                <div class="k">Téléphone</div>
                <div class="v">{profile.phone ?? "—"}</div>
            </div>
        </div>

        <div class="actions">
            <button class="btn" on:click={copyCitizenId}>Copier citizenid</button>
            <button
                    class="btn"
                    type="button"
                    on:click|stopPropagation={() => vehicle?.plate && vehicle?.plate}
            >
                Voir véhicules
            </button>
        </div>
    </aside>
{/if}

<style>
    .drawer{
        height: 100%;
        border-left: 1px solid rgba(255,255,255,.10);
        background: rgba(0,0,0,.12);
        padding: 12px;
        overflow: auto;
    }
    .drawer-top{
        display:flex; align-items:center; justify-content:space-between;
        margin-bottom: 10px;
    }
    .title{ font-weight: 800; letter-spacing: .2px; }
    .x{
        width: 34px; height: 34px;
        border-radius: 12px;
        border: 1px solid rgba(255,255,255,.12);
        background: rgba(255,255,255,.06);
        color: rgba(255,255,255,.9);
        cursor:pointer;
    }

    .card{
        background: rgba(255,255,255,.04);
        border: 1px solid rgba(255,255,255,.10);
        border-radius: 16px;
        padding: 12px;
    }
    .name{ font-size: 18px; font-weight: 900; }
    .meta{ margin-top: 8px; display:flex; gap: 8px; flex-wrap:wrap; }
    .chip{
        font-size: 12px;
        padding: 6px 8px;
        border-radius: 999px;
        border: 1px solid rgba(255,255,255,.10);
        background: rgba(0,0,0,.12);
    }
    .muted{ color: rgba(255,255,255,.62); }

    .grid{ margin-top: 12px; display:grid; gap: 10px; }
    .field{
        background: rgba(255,255,255,.03);
        border: 1px solid rgba(255,255,255,.08);
        border-radius: 14px;
        padding: 10px 12px;
    }
    .k{ color: rgba(255,255,255,.62); font-size: 12px; }
    .v{ margin-top: 4px; font-weight: 700; }

    .actions{ margin-top: 12px; display:flex; gap: 10px; }
    .btn{
        flex:1;
        padding: 12px 12px;
        border-radius: 14px;
        border: 1px solid rgba(255,255,255,.12);
        background: rgba(46,243,255,.10);
        color: rgba(255,255,255,.92);
        cursor:pointer;
    }
</style>